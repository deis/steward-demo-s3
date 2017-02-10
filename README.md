# Steward S3 Demo

This repository contains make targets intended to demo
[Steward CF](https://github.com/deis/steward-cf).

The following targets are available:

# steward

```
$ make steward
```

This target will create a `steward` namespace and install the Steward service
catalog controller into it.

# broker

```
$ make broker
```

This target will create an `s3-broker` namespace and install a service broker
into it. This particular service broker is for provisioning s3 buckets.

When both Steward and the broker are observed to be running, the target
will also register the broker with Steward by creating a `ServiceClass`. In
response, Steward will query the broker to learn what services and service plans
it offers. Steward will use these to add a `ServiceClass` to the service catalog.
The `ServiceClass` contains service and service plan details.

Because of its interaction with AWS, this broker requires the following
environment variables be defined to convey AWS credentials:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`

If these environment variables are left unset, the target will detect that and
fail fast.

# consumer

```
$ make broker
```

This target will create an example consumer that uploads a single image to
an s3 bucket. Naturally, this requires that a bucket exist and that the consumer
has credentials for writing to that bucket.

This target:

* Creates a `ServiceInstance` to effect provisioning of a new s3 bucket. This
  references the `ServiceClass` that was created when the broker was registered
  with Steward.
* Creates a `ServiceBinding` to provision credentials for that bucket. This
  references the provisioned bucket via the `ServiceInstance` created above.
  Steward will automatically inject the credentials into a `Secret`.
* Creates a `Job` that mounts the `Secret` created above and uses the
  credentials within to upload an image to the s3 bucket.

# clean-*

You can remove all of or parts of the demo using the following targets:

* `clean`
* `clean-consumer`
* `clean-broker`
* `clean-steward`
