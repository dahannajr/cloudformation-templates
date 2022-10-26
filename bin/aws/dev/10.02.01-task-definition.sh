#!/bin/bash


cd "$(dirname "$0")" && \
source .env && \
/usr/local/bin/aws cloudformation "$1"-stack \
  --stack-name "$CORE_STACK_NAME"-"$APPLICATION_NAME"-ecs-task-role \
  --template-url "$CF_TEMPLATE_URL_LOCATION"/ecs-task-definition-cf.yaml \
  --role-arn $CF_ROLE_ARN \
  --parameters \
    ParameterKey=AutoScalingTargetValue,ParameterValue=50,UsePreviousValue=false \
    ParameterKey=CertificateStackName,ParameterValue=,UsePreviousValue=false \
    ParameterKey=ContainersHaveMemoryReservations,ParameterValue=false,UsePreviousValue=false \
    ParameterKey=DesiredCountOfService,ParameterValue=1,UsePreviousValue=false \
    ParameterKey=ECRStacks,ParameterValue="$SHARED_STACK_NAME"-ecr-eidr-python38-tar-extractor\\,none\\,none\\,none\\,none,UsePreviousValue=false \
    ParameterKey=ECRTaskContainerPorts,ParameterValue=0\\,0\\,0\\,0\\,0\\,0\\,0\\,0\\,0\\,0,UsePreviousValue=false \
    ParameterKey=ECRTaskCpu,ParameterValue=1024,UsePreviousValue=false \
    ParameterKey=ECRTaskMemory,ParameterValue=4096,UsePreviousValue=false \
    ParameterKey=ECRTaskTags,ParameterValue=dev,UsePreviousValue=false \
    ParameterKey=ECSClusterStackName,ParameterValue="$CORE_STACK_NAME"-ecs-cluster,UsePreviousValue=false \
    ParameterKey=EnableDynamicPorts,ParameterValue=false,UsePreviousValue=false \
    ParameterKey=EnableFirelens,ParameterValue=false,UsePreviousValue=false \
    ParameterKey=EnableFluentd,ParameterValue=false,UsePreviousValue=false \
    ParameterKey=EnableLoadBalancerLogging,ParameterValue=false,UsePreviousValue=false \
    ParameterKey=HealthCheckPath,ParameterValue=/,UsePreviousValue=false \
    ParameterKey=HostedZoneName,ParameterValue=,UsePreviousValue=false \
    ParameterKey=HostedZoneId,ParameterValue=,UsePreviousValue=false \
    ParameterKey=LaunchType,ParameterValue=FARGATE,UsePreviousValue=false \
    ParameterKey=MaxContainers,ParameterValue=0,UsePreviousValue=false \
    ParameterKey=MemoryReservations,ParameterValue=0,UsePreviousValue=false \
    ParameterKey=MinContainers,ParameterValue=0,UsePreviousValue=false \
    ParameterKey=NetworkMode,ParameterValue=awsvpc,UsePreviousValue=false \
    ParameterKey=NumberOfContainers,ParameterValue=1,UsePreviousValue=false \
    ParameterKey=PublicHTTPPort,ParameterValue=0,UsePreviousValue=false \
    ParameterKey=PublicHTTPSPort,ParameterValue=0,UsePreviousValue=false \
    ParameterKey=Route53StackName,ParameterValue=,UsePreviousValue=false \
    ParameterKey=ServiceName,ParameterValue="$CORE_STACK_NAME"-"$APPLICATION_NAME"-ecs-task,UsePreviousValue=false \
    ParameterKey=ServiceRegistryEntriesCount,ParameterValue=0,UsePreviousValue=false \
    ParameterKey=ServiceRegistryEntryForContainers,ParameterValue=0,UsePreviousValue=false \
    ParameterKey=SecretStacks,ParameterValue=none\\,none\\,none\\,none\\,none\\,none\\,none\\,none\\,none\\,none,UsePreviousValue=false \
    ParameterKey=SecurityGroupStackName,ParameterValue=,UsePreviousValue=false  \
    ParameterKey=SecurityGroupStackExportVariableName,ParameterValue=,UsePreviousValue=false  \
    ParameterKey=Subdomain,ParameterValue=,UsePreviousValue=false \
    ParameterKey=TargetContainer,ParameterValue=0,UsePreviousValue=false \
    ParameterKey=VolumesBindCount,ParameterValue=0,UsePreviousValue=false \
    ParameterKey=VolumesBindNames,ParameterValue=,UsePreviousValue=false \
    ParameterKey=VPCStackName,ParameterValue="$CORE_STACK_NAME"-vpc,UsePreviousValue=false \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM