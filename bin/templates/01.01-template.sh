#!/bin/bash
cd "$(dirname "$0")" && \
  source .env && \
  STACK_NAME="$CORE_STACK_NAME-somename"

if [[ $1 = delete ]]
then 
  $AWS_CMD cloudformation "$1"-stack \
    --stack-name "$STACK_NAME"
else 
  $AWS_CMD cloudformation "$1"-stack \
    --stack-name "$STACK_NAME" \
    --template-body "$CF_TEMPLATE_LOCATION"/sometemplate-cf.yaml \
    --role-arn $CF_ROLE_ARN \
    "$AWS_REGION" \
    --parameters \
      ParameterKey=AvailabilityZones,ParameterValue=us-east-1a\\,us-east-1b,UsePreviousValue=false \
    --capabilities CAPABILITY_NAMED_IAM
fi
