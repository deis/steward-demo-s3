# Steward/S3 Consumer Application

This [Helm](https://github.com/kubernetes/helm) chart installs an application that takes advantage of a [Steward](https://github.com/deis/steward)-provisioned S3 bucket.

# Installation

Before this application will properly work, you must install the [s3-service-provider chart](https://github.com/deis/steward-demo-s3/tree/master/charts/s3-service-provider) chart.

However, you may install this chart before that chart, and watch this fail to start until that chart's claim is completely installed properly.

Installation of this chart is simple. Assuming the following:

- You have the `helm` CLI and the Tiller server running (simply `helm init` to get the latter)
- Your current working directory is this folder
- There is no `steward` namespace in your cluster

... install with this command:

```console
helm install .  --namespace=steward
```
