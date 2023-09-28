#!/bin/bash

args=()  # Create an empty array to store our arguments

# Check if PARAMETERS has any values
if [ "${#PARAMETERS[@]}" -gt 0 ]; then
  args+=("--parameters")
  args+=("${PARAMETERS[@]}")  # This appends all the values from PARAMETERS to args
fi

# Check if CAPABILITIES has any values
if [ "${#CAPABILITIES[@]}" -gt 0 ]; then
  args+=("--capabilities")
  args+=("${CAPABILITIES[@]}")  # This appends all the values from PARAMETERS to args
fi

# Using stack-specific details in the command
if [[ $1 = delete ]]; then 
  # Delete the stack
  $AWS_CMD cloudformation "$1"-stack \
    --no-cli-auto-prompt --no-cli-pager \
    --stack-name "$STACK_NAME" \
    $CF_ROLE_ARN_ARG \
    $CF_AWS_PROFILE \
    $AWS_REGION
else 
  $AWS_CMD cloudformation "$1"-stack \
    --no-cli-auto-prompt --no-cli-pager \
    --stack-name $STACK_NAME \
    $CF_ROLE_ARN_ARG \
    $CF_AWS_PROFILE \
    $AWS_REGION \
    $TEMPLATE_LOCATION \
    "${args[@]}"
fi


while true; do
  # Get stack status
  STACK_STATUS=$($AWS_CMD cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    $CF_AWS_PROFILE \
    $AWS_REGION \
    --query "Stacks[0].StackStatus" --output text)

  case $STACK_STATUS in
    CREATE_IN_PROGRESS|DELETE_IN_PROGRESS|UPDATE_IN_PROGRESS)
      echo "Current stack status: $STACK_STATUS. Waiting..."
      sleep 10
      ;;
    CREATE_COMPLETE)
      echo "Stack creation completed!"
      break
      ;;
    UPDATE_COMPLETE)
      echo "Stack update completed!"
      break
      ;;
    DELETE_COMPLETE)
      echo "Stack deletion completed!"
      exit 0
      ;;
    CREATE_FAILED|ROLLBACK_IN_PROGRESS|ROLLBACK_FAILED|ROLLBACK_COMPLETE|DELETE_FAILED)
      echo "An error occurred: $STACK_STATUS"
      exit 1
      ;;
    *)
      echo "Unknown status: $STACK_STATUS. Exiting."
      exit 1
      ;;
  esac

  clear;

  # Describe stack events
  $AWS_CMD cloudformation describe-stack-events \
    --no-cli-auto-prompt --no-cli-pager \
    --stack-name "$STACK_NAME" \
    $CF_AWS_PROFILE \
    $AWS_REGION \
    --query "StackEvents[].[LogicalResourceId, ResourceStatus, ResourceType, Timestamp]" \
    --output table

  sleep 2
done