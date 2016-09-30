# Steward Service Plan Claim

This [Helm](https://github.com/kubernetes/helm) chart installs a new Steward [service plan claim](https://github.com/deis/steward/blob/master/doc/DATA_STRUCTURES.md#serviceplanclaim) to create a new S3 bucket and bind to it. The binding process creates new IAM credentials to access the bucket

# Installation

Installation of this chart is simple. Assuming the following:

- You have the `helm` CLI and the Tiller server running (simply `helm init` to get the latter)
- Your current working directory is this folder

... install with this command:

```console
helm install .  --namespace=steward
```
