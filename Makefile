OS := $(shell uname)
ifeq ($(OS),Darwin)
	UUID_CMD := bin/darwin/amd64/uuid
else
	UUID_CMD := bin/linux/amd64/uuid
endif

clean: clean-consumer clean-broker clean-steward

steward:
	kubectl create -f manifests/steward.yaml

clean-steward:
	kubectl delete namespace steward || true
	kubectl delete thirdpartyresource service-binding.steward.deis.io || true
	kubectl delete thirdpartyresource service-instance.steward.deis.io || true
	kubectl delete thirdpartyresource service-class.steward.deis.io || true
	kubectl delete thirdpartyresource service-broker.steward.deis.io || true

broker:
ifndef AWS_ACCESS_KEY_ID
	$(error AWS_ACCESS_KEY_ID is undefined)
endif
ifndef AWS_SECRET_ACCESS_KEY
	$(error AWS_SECRET_ACCESS_KEY is undefined)
endif
	@sed "s/#aws-access-key-id#/$$(printf ${AWS_ACCESS_KEY_ID} | base64)/" manifests/s3-service-provider-template.yaml > manifests/s3-service-provider.yaml
	@sed -i.bak "s/#aws-secret-access-key#/$$(printf ${AWS_SECRET_ACCESS_KEY} | base64)/" manifests/s3-service-provider.yaml
	@rm manifests/s3-service-provider.yaml.bak
	kubectl create -f manifests/s3-service-provider.yaml
	@echo "Waiting for Steward to be running..."
	@until kubectl get pods -n steward | grep Running | grep "1/1" &> /dev/null; do printf . ; sleep 1; done
	@echo
	@echo "Waiting for ServiceBroker kind to be available..."
	@until kubectl get thirdpartyresource service-broker.steward.deis.io &> /dev/null; do printf . ; sleep 1; done
	@echo
	@echo "Waiting for the broker to be running..."
	@until kubectl get pods -n s3-broker | grep Running | grep "1/1" &> /dev/null; do printf . ; sleep 1; done
	@echo
	@echo "Registering the broker..."
	kubectl create -f manifests/servicebroker.yaml

clean-broker:
	kubectl delete namespace s3-broker || true
	kubectl delete servicebroker s3-broker -n steward || true
	kubectl delete serviceclass s3-broker-bucket -n steward || true

consumer:
	@sed "s/#instance-uuid#/$$(${UUID_CMD})/" manifests/serviceinstance-template.yaml > manifests/serviceinstance.yaml
	@echo "Waiting for ServiceBroker to be Available..."
	@until kubectl get servicebroker s3-broker -n steward -o yaml | grep "state: Available" &> /dev/null; do printf . ; sleep 1; done
	@echo
	kubectl create -f manifests/serviceinstance.yaml
	@sed "s/#binding-uuid#/$$(${UUID_CMD})/" manifests/servicebinding-template.yaml > manifests/servicebinding.yaml
	@echo "Waiting for ServiceInstance to be Provisioned..."
	@until kubectl get serviceinstance my-s3-bucket -n default -o yaml | grep "status: Provisioned" &> /dev/null; printf . ; do sleep 1; done
	@for i in $$(seq 1 10); do printf . ; sleep 1; done
	@echo
	kubectl create -f manifests/servicebinding.yaml
	@echo "Waiting for ServiceBinding to be Bound..."
	@until kubectl get servicebinding my-s3-bucket-binding -n default -o yaml | grep "state: Bound" &> /dev/null; printf . ; do sleep 1; done
	@for i in $$(seq 1 10); do printf . ; sleep 1; done
	@echo
	@echo "Scheduling consumer job (s3 upload job)..."
	kubectl create -f manifests/s3-uploader.yaml

clean-consumer:
	kubectl delete job s3-uploader -n default || true
	kubectl delete secret my-s3-bucket-creds -n default || true
	kubectl delete servicebinding my-s3-bucket-binding -n default || true
	kubectl delete serviceinstance my-s3-bucket -n default || true
