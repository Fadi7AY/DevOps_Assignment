#!/bin/bash

aws lambda invoke \
  --function-name list-s3-files-2 \
  --region eu-central-1 \
  --payload '{}' \
  --cli-binary-format raw-in-base64-out \
  response.json

echo "Lambda invoked. Response saved to response.json"
