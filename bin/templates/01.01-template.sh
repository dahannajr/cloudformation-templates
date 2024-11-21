#!/bin/bash
cd "$(dirname "$0")" && \
  source .env && \

STACK_NAME="$CORE_STACK_NAME-somename"
TEMPLATE_LOCATION="$CF_TEMPLATE_LOCATION/sometemplate-cf.yaml"
PARAMETERS=(
  "ParameterKey=Container1AppProtocol,ParameterValue=http,UsePreviousValue=false"
  "ParameterKey=Container1ContainerName,ParameterValue=ticketapi,UsePreviousValue=false"
)
CAPABILITIES=(
  "CAPABILITY_NAMED_IAM" 
  "CAPABILITY_AUTO_EXPAND"
) 

source /dev/stdin <<< "$(curl --insecure https://kickstep-cf-templates.s3.amazonaws.com/cloudformation_templates/cf-utility.sh)" $1; 



#!/bin/bash
source .scala-api.env 

read -r -d '' JSON << EOM
{
  "ACCESS_TOKEN_SECRET_KEY": "",
  "ADMIN_USER_TOKEN": "",
  "DB_DATABASE": "",
  "DB_PASSWORD": "",
  "DB_SERVER": "",
  "DB_PORT": "",
  "DB_USERNAME": "",
  "DEBUG": "",
  "JWT_CLAIM": "",
  "JWT_SECRET_KEY": "",
  "PASSWORD_SALT": ""
}
EOM

ESCAPED_JSON=$(echo "$JSON" | jq -c .| sed 's/"/\\"/g')

STACK_NAME="$CORE_STACK_NAME-auth-service-secrets-$APPLICATION_NAME"
TEMPLATE_LOCATION="$CF_TEMPLATE_LOCATION/sm-secrets-cf.yaml"
PARAMETERS=(
  "ParameterKey=Name,ParameterValue=$STACK_NAME,UsePreviousValue=false"
  "ParameterKey=Description,ParameterValue=\"Secrets to be injected into the Task Definitions used by thea Auth Service Connect\",UsePreviousValue=false"
  "ParameterKey=SecretString,ParameterValue=\"$ESCAPED_JSON\",UsePreviousValue=false"
)
CAPABILITIES=() #"CAPABILITY_IAM" "CAPABILITY_NAMED_IAM")  # add or remove capabilities as needed

source /dev/stdin <<< "$(curl --insecure https://kickstep-cf-templates.s3.amazonaws.com/cloudformation_templates/cf-utility.sh)" $1; 