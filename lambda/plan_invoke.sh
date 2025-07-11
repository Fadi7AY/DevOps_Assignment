#!/bin/bash

set -e

terraform plan -out=tfplan.out > plan_output.txt

if grep -qE 'No changes|No changes\. Infrastructure is up-to-date\.' plan_output.txt; then
  echo "No infrastructure changes. Invoking Lambda"
  ../lambda/lambda_test.sh
else
  echo "Changes detected. Lambda will be invoked via Terraform Apply."
fi
