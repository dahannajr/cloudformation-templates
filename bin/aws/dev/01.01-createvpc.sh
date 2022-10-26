#!/bin/bash

cd "$(dirname "$0")" && \
source .env && \
/usr/local/bin/aws cloudformation "$1"-stack \
  --stack-name "$CORE_STACK_NAME"-vpc \
  --template-url "$CF_TEMPLATE_URL_LOCATION"/vpc-cf.yaml \
  --role-arn $CF_ROLE_ARN \
  --parameters \
  ParameterKey=AvailabilityZones,ParameterValue=us-west-2a\\,us-west-2b,UsePreviousValue=false \
  ParameterKey=CreateNATGatewayAZ1,ParameterValue=false,UsePreviousValue=false \
  ParameterKey=CreateNATGatewayAZ2,ParameterValue=false,UsePreviousValue=false \
  ParameterKey=CreateNATGatewayAZ3,ParameterValue=false,UsePreviousValue=false \
  ParameterKey=PrivateSubnet1ACIDR,ParameterValue=172.20.130.0/24,UsePreviousValue=false \
  ParameterKey=PrivateSubnet2ACIDR,ParameterValue=172.20.131.0/24,UsePreviousValue=false \
  ParameterKey=PrivateSubnet1BCIDR,ParameterValue=172.20.132.0/24,UsePreviousValue=false \
  ParameterKey=PrivateSubnet2BCIDR,ParameterValue=172.20.133.0/24,UsePreviousValue=false \
  ParameterKey=PublicSubnet1CIDR,ParameterValue=172.20.128.0/24,UsePreviousValue=false \
  ParameterKey=PublicSubnet2CIDR,ParameterValue=172.20.129.0/24,UsePreviousValue=false \
  ParameterKey=VPCCIDR,ParameterValue=172.20.128.0/20,UsePreviousValue=false \
  ParameterKey=VPCTenancy,ParameterValue=default,UsePreviousValue=false 