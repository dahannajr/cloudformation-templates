#!/bin/bash
cd "$(dirname "$0")" && \
  source .env && \
  STACK_NAME="$CORE_STACK_NAME"-sg-vpce-ecr

if [[ $1 = delete ]]
then 
  $AWS_CMD cloudformation "$1"-stack \
    --stack-name "$STACK_NAME"
else 
  $AWS_CMD cloudformation "$1"-stack \
    --stack-name "$STACK_NAME" \
    --template-body "$CF_TEMPLATE_LOCATION"/ec2-sg-cf.yaml \
    --role-arn $CF_ROLE_ARN \
    --parameters \
      ParameterKey=AllowIngressFromSelf,ParameterValue=true,UsePreviousValue=false \
      ParameterKey=VPCStackName,ParameterValue="$CORE_STACK_NAME-vpc-$APPLICATION_NAME",UsePreviousValue=false

fi