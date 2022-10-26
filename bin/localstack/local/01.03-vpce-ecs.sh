#!/bin/bash
cd "$(dirname "$0")" && \
  source .env && \
  STACK_NAME="$CORE_STACK_NAME"-vpce-to-ecs

if [[ $1 = delete ]]
then 
  $AWS_CMD cloudformation "$1"-stack \
    --stack-name "$STACK_NAME"
else 
  $AWS_CMD cloudformation "$1"-stack \
    --stack-name "$STACK_NAME" \
    --template-body "$CF_TEMPLATE_LOCATION"/vpc-endpoint-cf.yaml \
    --role-arn $CF_ROLE_ARN \
    --parameters \
      ParameterKey=PrivateDnsEnabled,ParameterValue=true,UsePreviousValue=false \
      ParameterKey=SecurityGroupStacks,ParameterValue="$CORE_STACK_NAME"-sg-vpce-ecr,UsePreviousValue=false \
      ParameterKey=SecurityGroupStackCount,ParameterValue=1,UsePreviousValue=false \
      ParameterKey=SecurityGroupStackExportVariable,ParameterValue=SecurityGroupId,UsePreviousValue=false \
      ParameterKey=ServiceName,ParameterValue=ecs,UsePreviousValue=false \
      ParameterKey=StackSubnetIdCount,ParameterValue=2,UsePreviousValue=false \
      ParameterKey=StackSubnetIds,ParameterValue=PrivateSubnet1BID\\,PrivateSubnet2BID,UsePreviousValue=false \
      ParameterKey=VpcEndpointType,ParameterValue=Interface,UsePreviousValue=false \
      ParameterKey=VPCStackName,ParameterValue="$CORE_STACK_NAME-vpc-$APPLICATION_NAME",UsePreviousValue=false
fi
