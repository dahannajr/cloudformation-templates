#!/bin/bash

cd "$(dirname "$0")" && \
source .env && \
/usr/local/bin/aws cloudformation "$1"-stack \
  --stack-name "$CORE_STACK_NAME"-ecs-cluster \
  --template-url "$CF_TEMPLATE_URL_LOCATION"/ecs-cluster-cf.yaml \
  --role-arn $CF_ROLE_ARN \
  --parameters \
  ParameterKey=ClusterName,ParameterValue="$APPLICATION_NAME",UsePreviousValue=false  \
  ParameterKey=EnableContainerInsights,ParameterValue=true,UsePreviousValue=false \
  ParameterKey=EnvironmentStage,ParameterValue="$APPLICATION_ENVIRONMENT",UsePreviousValue=false  \
  --capabilities CAPABILITY_IAM