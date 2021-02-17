#!/bin/bash

# Set profile in the local aws credentials file for use below
PROFILE="<profile from aws credentials file>"
ACCOUNT_ID=$(aws sts get-caller-identity --profile $PROFILE |  jq -r '.Account')
REGIONS=("eu-west-1" "eu-west-2" "us-east-1" "ap-northeast-1")
ROLE_ARN="arn:aws:iam::$ACCOUNT_ID:role/AWSDataLifecycleManagerDefaultRole"

aws dlm create-default-role --region $REGIONS \
    --profile $PROFILE \

for REGION in ${REGIONS[@]}
do
    aws dlm create-lifecycle-policy --state ENABLED \
    --description "EBS Snapshot Policy 8 Day Retention" \
    --execution-role-arn $ROLE_ARN \
    --policy-details file://ebs-snapshot-8day.json \
    --tags Project="Data Protection" \
    --region $REGION --profile $PROFILE

    aws dlm create-lifecycle-policy --state ENABLED \
    --description "EBS Snapshot Policy 14 Day Retention" \
    --execution-role-arn $ROLE_ARN \
    --policy-details file://ebs-snapshot-14day.json \
    --tags Project="Data Protection" \
    --region $REGION --profile $PROFILE

    aws dlm create-lifecycle-policy --state ENABLED \
    --description "EBS Snapshot Policy 30 Day Retention" \
    --execution-role-arn $ROLE_ARN \
    --policy-details file://ebs-snapshot-30day.json \
    --tags Project="Data Protection" \
    --region $REGION --profile $PROFILE
done
