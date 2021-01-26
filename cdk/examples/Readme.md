# Example AWS CDK Deployment of an S3 Bucket

This document explains how to use the example CDK deployment using Python in the folder 'cdk-example-s3'. This deploys a simple S3 bucket in the AWS eu-west-2 region.

## Requirements
CDK must be deployed. The script install-cdk-python.sh in the cdk folder is provided to do this.

Valid AWS credentials must be in place on the workstation. (~/.aws/credentials)

## Usage

from within the cdk-example-s3 folder, execute:
``` 
source .venv/bin/activate
```

Once in the virtual environment, install the required pip modules:
```
pip3 install -r requirements.txt
```
Generate an AWS CloudFormation template:
```
cdk synth
```

Deploy the Template to AWS
```
cdk deploy
```

This will deploy the CloudFormation template to AWS using the default credentials in the AWS Credentials file on your workstation.

To remove the S3 bucket in the example, and delete the CloudFormation stack:
```
cdk destroy
```
