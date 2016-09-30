# S3 Service Provider

This [Helm](https://github.com/kubernetes/helm) chart installs [Steward](https://github.com/deis/steward) and a CloudFoundry service broker that can provision [S3](https://aws.amazon.com/s3/) buckets and provide access to it.

# Installation

Installation is simple. Assuming the following:

- You have the `helm` CLI and the Tiller server running (simply `helm init` to get the latter)
- You have a valid AWS access and and AWS secret in your environment (`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`, respectively)
- Your current working directory is this folder
- There is no `steward` namespace in your cluster

... install with this command:

```console
helm install . --set AdminAwsAccessKeyId=${AWS_ACCESS_KEY_ID},AdminAwsSecretAccessKey=${AWS_SECRET_ACCESS_KEY} --namespace steward
```
