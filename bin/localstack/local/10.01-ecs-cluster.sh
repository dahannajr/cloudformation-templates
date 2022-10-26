#!/bin/bash
cd "$(dirname "$0")" && \
  source .env && \
  STACK_NAME="$CORE_STACK_NAME"-ecs-cluster

if [[ $1 = delete ]]
then 
  $AWS_CMD cloudformation "$1"-stack \
    --stack-name "$STACK_NAME"
else 
  $AWS_CMD cloudformation "$1"-stack \
    --stack-name "$STACK_NAME" \
    $CF_TEMPLATE_LOCATION/ecs-cluster-cf.yaml \
    $CF_ROLE_ARN_ARG \
    --parameters \
    ParameterKey=ClusterName,ParameterValue="$APPLICATION_NAME",UsePreviousValue=false  \
    ParameterKey=EnableContainerInsights,ParameterValue=true,UsePreviousValue=false \
    ParameterKey=EnvironmentStage,ParameterValue="$APPLICATION_ENVIRONMENT",UsePreviousValue=false  \
    ParameterKey=IsLocalStack,ParameterValue="$IS_LOCALSTACK",UsePreviousValue=false \
    --capabilities CAPABILITY_IAM
fi
