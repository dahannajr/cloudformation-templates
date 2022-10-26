#!/bin/bash
cd "$(dirname "$0")" && \
  source .env && \
  STACK_NAME="$CORE_STACK_NAME"-cognito

if [[ $1 = delete ]]
then 
  $AWS_CMD cloudformation "$1"-stack \
    --stack-name "$STACK_NAME"
else 
  $AWS_CMD cloudformation "$1"-stack \
    --stack-name "$STACK_NAME" \
    $CF_TEMPLATE_LOCATION/cognito-cf.yaml \
    $CF_ROLE_ARN_ARG \
    --capabilities CAPABILITY_IAM
fi
