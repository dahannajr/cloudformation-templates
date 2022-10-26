#!/bin/bash

cd "$(dirname "$0")" && \
source .env && \
/usr/local/bin/aws cloudformation "$1"-stack \
  --stack-name "$CORE_STACK_NAME"-vpce-s3-gateway \
  --template-url "$CF_TEMPLATE_URL_LOCATION"/vpc-endpoint-cf.yaml \
  --role-arn $CF_ROLE_ARN \
  --parameters \
  ParameterKey=PrivateDnsEnabled,ParameterValue=true,UsePreviousValue=false \
  ParameterKey=ServiceName,ParameterValue=s3,UsePreviousValue=false \
  ParameterKey=StackSubnetIdCount,ParameterValue=0,UsePreviousValue=false \
  ParameterKey=StackSubnetIds,ParameterValue=,UsePreviousValue=false \
  ParameterKey=VpcEndpointType,ParameterValue=Gateway,UsePreviousValue=false \
  ParameterKey=VPCStackName,ParameterValue="$CORE_STACK_NAME"-vpc,UsePreviousValue=false \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM
