#!/bin/bash

cd "$(dirname "$0")" && \
source .env && \
/usr/local/bin/aws cloudformation "$1"-stack \
  --stack-name "$CORE_STACK_NAME"-ecr-eidr-python39-tar-extractor \
  --template-url "$CF_TEMPLATE_URL_LOCATION"/ecr-cf.yaml \
  --role-arn $CF_ROLE_ARN \
  --parameters \
    ParameterKey=ServiceName,ParameterValue="ecs",UsePreviousValue=false
