# Steward S3 Demo

This repository contains helm charts intended to demo Steward. They currently only demo Steward's CloudFoundry integration.

The following charts are available:

# charts/s3-service-provider

This chart installs the following:

* A configured s3-cf-broker (the broker is taken from a [CloudFoundry community implementation](https://github.com/cloudfoundry-community/s3-broker)
* A Steward configured in CloudFoundry mode and pointed at the aforementioned broker

## Broker Details

On provision, the broker will create an S3 bucket. On bind, the broker will create an IAM user and grant acccess to the aforementioned bucket.

## Steward Details

After a bind, Steward will drop the bucket-name, AWS_ACCESS_KEY, AWS_SECRET_KEY into a kubernetes secret, which will look like the following:

```yaml
kind: Secret
apiVersion: v1
data:
  name: <s3 bucket name>
  password: <AWS_SECRET_KEY>
  username: <AWS_ACCESS_KEY>
```

# charts/sample-s3-uploader

This chart installs the following:

* A Steward [service plan claim](https://github.com/deis/steward/blob/master/doc/DATA_STRUCTURES.md#serviceplanclaim)
* An application (run as a Kubernetes job) that consumes the credentials produced by steward (as a result of the aforementioned claim) and writes data to the newly created bucket


# Prerequisites

You must have AWS credentials with full S3 and IAM access. The access key should be stored in the `AWS_ACCESS_KEY_ID` environment variable, and the secret should be stored in the `AWS_SECRET_ACCESS_KEY` environment variable.

# Demo

In order to use these helm charts to show a start-to-finish demo of Steward's capability, first install the `s3-service-provider` chart, then install the `sample-s3-uploader` chart. See the charts for installation details:

- [s3-service-provider](./charts/s3-service-provider)
- [sample-s3-uploader](./charts/sample-s3-uploader)

The `sample-s3-uploader` chart will install a job in the `steward` namespace. After that job completes successfully, a new bucket and file (in the bucket) will have been created. Use either the AWS CLI or in-browser interface to see the file.
