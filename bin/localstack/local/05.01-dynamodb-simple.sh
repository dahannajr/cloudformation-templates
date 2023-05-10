#!/bin/bash
cd "$(dirname "$0")" && \
  source .env && \
  STACK_NAME="$APPLICATION_ENVIRONMENT"-"$APPLICATION_NAME"-dynamodb-simple

if [[ $1 = delete ]]; then 
  $AWS_CMD cloudformation "$1"-stack \
    --stack-name "$STACK_NAME" \
    $CF_AWS_PROFILE
elif [[ $1 = describe ]]; then
  $AWS_CMD cloudformation describe-stacks \
    --stack-name "$STACK_NAME" \
    $CF_AWS_PROFILE
else
  $AWS_CMD cloudformation "$1"-stack \
    --stack-name "$STACK_NAME" \
    $CF_AWS_PROFILE \
    $CF_TEMPLATE_LOCATION/dynamodb-table-cf.yaml \
    $CF_ROLE_ARN_ARG \
    --parameters \
      ParameterKey=BillingMode,ParameterValue=PROVISIONED,UsePreviousValue=false \
      ParameterKey=TableName,ParameterValue=Albumn,UsePreviousValue=false \
    --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM
fi