#!/bin/bash

cd "$(dirname "$0")" && \
source .env && \
/usr/local/bin/aws cloudformation "$1"-stack \
  --stack-name "$CORE_STACK_NAME"-vpce-to-logs \
  --template-url "$CF_TEMPLATE_URL_LOCATION"/vpc-endpoint-cf.yaml \
  --role-arn $CF_ROLE_ARN \
  --parameters \
  ParameterKey=PrivateDnsEnabled,ParameterValue=true,UsePreviousValue=false \
  ParameterKey=SecurityGroupStacks,ParameterValue="$CORE_STACK_NAME"-sg-vpce-logs,UsePreviousValue=false \
  ParameterKey=SecurityGroupStackCount,ParameterValue=1,UsePreviousValue=false \
  ParameterKey=SecurityGroupStackExportVariable,ParameterValue=SecurityGroupId,UsePreviousValue=false \
  ParameterKey=ServiceName,ParameterValue=logs,UsePreviousValue=false \
  ParameterKey=StackSubnetIdCount,ParameterValue=2,UsePreviousValue=false \
  ParameterKey=StackSubnetIds,ParameterValue=PrivateSubnet1BID\\,PrivateSubnet2BID,UsePreviousValue=false \
  ParameterKey=VpcEndpointType,ParameterValue=Interface,UsePreviousValue=false \
  ParameterKey=VPCStackName,ParameterValue="$CORE_STACK_NAME"-vpc,UsePreviousValue=false

