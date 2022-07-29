#!/bin/bash
#Name of the state bucket
TERRAFORM_S3_BUCKET_NAME=terraform-cloud-state-bucket
REGION=eu-central-1

if aws s3 ls "s3://$TERRAFORM_S3_BUCKET_NAME" 2>&1 | grep -q 'An error occurred'
then
    aws s3api create-bucket --bucket $TERRAFORM_S3_BUCKET_NAME --region $REGION  --create-bucket-configuration LocationConstraint=$REGION
else
    echo "Terraform bucket to store state file exists already"
fi