#!/usr/bin/env python3

from aws_cdk import core

from cdk_example_s3.cdk_example_s3_stack import CdkExampleS3Stack


app = core.App()
CdkExampleS3Stack(app, "cdk-example-s3", env={'region': 'eu-west-2'})

app.synth()
