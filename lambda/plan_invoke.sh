#!/bin/bash

set +e

# Run Terraform plan with detailed exit code and output to file
terraform plan -detailed-exitcode -out=tfplan.out
code=$?

echo "******* exit code is -$code- ***********"

if [ "$code" -eq 0 ]; then
  echo "No infrastructure changes. Invoking Lambda"
  ../lambda/lambda_test.sh
elif [ "$code" -eq 2 ]; then
  echo "Changes detected. Lambda will be invoked via Terraform Apply."
else
  echo "Terraform plan failed with exit code $code"
  exit $code
fi
