#!/bin/bash

cd "$(dirname "$0")" && \
source .env && \
/usr/local/bin/aws cloudformation "$1"-stack \
  --stack-name "$CORE_STACK_NAME"-sg-vpce-logs \
  --template-url "$CF_TEMPLATE_URL_LOCATION"/ec2-sg-cf.yaml \
  --role-arn $CF_ROLE_ARN \
  --parameters \
  ParameterKey=AllowIngressFromSelf,ParameterValue=true,UsePreviousValue=false \
  ParameterKey=VPCStackName,ParameterValue="$CORE_STACK_NAME"-vpc,UsePreviousValue=false