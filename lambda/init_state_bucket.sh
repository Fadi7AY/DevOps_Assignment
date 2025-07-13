#!/bin/bash

BUCKET_NAME="terraform-state-fadi7ay-testing2"
REGION="eu-central-1"

if ! aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo " Bucket does not exist. Creating..."
  aws s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --region "$REGION" \
    --create-bucket-configuration LocationConstraint="$REGION"

  echo "Bucket '$BUCKET_NAME' created successfully."

else
  echo "Bucket '$BUCKET_NAME' already exists. Skipping creation."
fi
