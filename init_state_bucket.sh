#!/bin/bash

aws s3api create-bucket \
  --bucket terraform-state-file-fadi7 \
  --region eu-central-1 \
  --create-bucket-configuration LocationConstraint=eu-central-1
