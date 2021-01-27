from aws_cdk import (
    aws_s3 as s3,
    core
)


class CdkExampleS3Stack(core.Stack):

    def __init__(self, scope: core.Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        bucket = s3.Bucket(
            self, "mytestbucket",
            bucket_name="mytestbucket.mydomain.com"
        )

        bucket.node.find_child('Resource').cfn_options.deletion_policy = core.CfnDeletionPolicy.DELETE