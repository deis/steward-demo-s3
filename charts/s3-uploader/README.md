# Steward/S3 Consumer Application

This [Helm](https://github.com/kubernetes/helm) chart installs an application and a claim that provisions a new S3 bucket with [Steward](https://github.com/deis/steward).

# Installation

Installation of this chart is simple. Assuming the following:

- You have the `helm` CLI and the Tiller server running (simply `helm init` to get the latter)
- Your current working directory is this folder

... install with this command:

```console
helm install .  --namespace=steward
```
