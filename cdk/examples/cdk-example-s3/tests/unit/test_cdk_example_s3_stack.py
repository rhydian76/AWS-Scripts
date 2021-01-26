import json
import pytest

from aws_cdk import core
from cdk-example-s3.cdk_example_s3_stack import CdkExampleS3Stack


def get_template():
    app = core.App()
    CdkExampleS3Stack(app, "cdk-example-s3")
    return json.dumps(app.synth().get_stack("cdk-example-s3").template)


def test_sqs_queue_created():
    assert("AWS::SQS::Queue" in get_template())


def test_sns_topic_created():
    assert("AWS::SNS::Topic" in get_template())
