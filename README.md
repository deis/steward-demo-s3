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

# charts/claim

This chart installs the following:

* A Steward [service plan claim](https://github.com/deis/steward/blob/master/doc/DATA_STRUCTURES.md#serviceplanclaim) to provision and bind (`action: create`) a new S3 bucket and IAM credentials to access that bucket

# charts/sample-s3-uploader

This chart installs the following:

* An application (run as a Kubernetes job) that consumes the credentials produced by steward (as a result of the aforementioned claim) and writes data to the newly created bucket


# Prerequisites

You must have AWS credentials with full S3 and IAM access. The access key should be stored in the `AWS_ACCESS_KEY_ID` environment variable, and the secret should be stored in the `AWS_SECRET_ACCESS_KEY` environment variable.

# Demo

In order to use these helm charts to show a start-to-finish demo of Steward's capability, install the following charts in order:

1. [s3-service-provider](./charts/s3-service-provider) - installs steward and the backing broker
2. [claim](./charts/claim) - submits an `action: create` claim to steward, which in turn calls the CF broker
  - The CF broker creates new IAM credentials. Before proceeding past this step, wait a bit for the new creds to be pushed across regions
3. [sample-s3-uploader](./charts/sample-s3-uploader) - installs the application that consumes the newly created bucket using the new IAM credentials
