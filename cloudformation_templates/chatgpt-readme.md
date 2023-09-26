# Assistance Requirements

I build my CloudFormation templates so that multiple clients can use the same templates and all they require is the AWS CLI and the ability to run Bash shell scripts.  This means that the template are highly parameterized, outputs are exported, and the tmplates setup so that they're either the individual components of a solution or the combining/orchestration of a solution.  For example, I have a VPC cloudformation template as follows:

```
AWSTemplateFormatVersion: '2010-09-09'
Description: >-
  This template creates a Multi-AZ, multi-subnet VPC infrastructure with managed NAT
  gateways in the public subnet for each Availability Zone.
Parameters:
  AvailabilityZones:
    Description: 'List of Availability Zones to use for the subnets in the VPC. Note:
      The logical order is preserved.'
    Type: List<AWS::EC2::AvailabilityZone::Name>
  CreateNATGatewayAZ1:
    AllowedValues:
      - 'true'
      - 'false'
    Default: 'false'
    Description: Create a NAT Gateway in Public Subnet for AZ 1
    Type: String
  CreateNATGatewayAZ2:
    AllowedValues:
      - 'true'
      - 'false'
    Default: 'false'
    Description: Create a NAT Gateway in Public Subnet for AZ 2
    Type: String
  CreateNATGatewayAZ3:
    AllowedValues:
      - 'true'
      - 'false'
    Default: 'false'
    Description: Create a NAT Gateway in Public Subnet for AZ 3
    Type: String
  PrivateSubnet1ACIDR:
    AllowedPattern: ^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/(1[6-9]|2[0-8]))$|^$
    ConstraintDescription: CIDR block parameter must be in the form x.x.x.x/16-28
    Description: CIDR block for private subnet 1A located in Availability Zone 1
    Type: String
    Default: ''
  PrivateSubnet1BCIDR:
    AllowedPattern: ^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/(1[6-9]|2[0-8]))$|^$
    ConstraintDescription: CIDR block parameter must be in the form x.x.x.x/16-28
    Description: CIDR block for private subnet 1B located in Availability Zone 2
    Type: String
    Default: ''
  
  # ... More Parameters

  VPCCIDR:
    AllowedPattern: ^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/(1[6-9]|2[0-8]))$
    ConstraintDescription: CIDR block parameter must be in the form x.x.x.x/16-28
    Description: CIDR block for the VPC
    Type: String
  VPCTenancy:
    AllowedValues:
      - default
      - dedicated
    Default: default
    Description: The allowed tenancy of instances launched into the VPC
    Type: String
Conditions:
  NATGatewayAZ1Condition: !Equals
    - !Ref 'CreateNATGatewayAZ1'
    - 'true'
  NATGatewayAZ2Condition: !Equals
    - !Ref 'CreateNATGatewayAZ2'
    - 'true'
  NATGatewayAZ3Condition: !Equals
    - !Ref 'CreateNATGatewayAZ3'
    - 'true'
  NVirginiaRegionCondition: !Equals
    - !Ref 'AWS::Region'
    - us-east-1
  
  # More Conditions.

Resources:
  DHCPOptions:
    Type: AWS::EC2::DHCPOptions
    Properties:
      DomainName: !If
        - NVirginiaRegionCondition
        - ec2.internal
        - !Sub '${AWS::Region}.compute.internal'
      DomainNameServers:
        - AmazonProvidedDNS
  VPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: !Ref 'VPCCIDR'
      InstanceTenancy: !Ref 'VPCTenancy'
      EnableDnsSupport: true
      EnableDnsHostnames: true
      Tags:
        - Key: Name
          Value: !Ref 'AWS::StackName'
  VPCDHCPOptionsAssociation:
    Type: AWS::EC2::VPCDHCPOptionsAssociation
    Properties:
      VpcId: !Ref 'VPC'
      DhcpOptionsId: !Ref 'DHCPOptions'
  InternetGateway:
    Condition: PublicSubnetsCondition
    Type: AWS::EC2::InternetGateway
    Properties:
      Tags:
        - Key: Name
          Value: !Ref 'AWS::StackName'
  VPCGatewayAttachment:
    Condition: PublicSubnetsCondition
    Type: AWS::EC2::VPCGatewayAttachment
    Properties:
      VpcId: !Ref 'VPC'
      InternetGatewayId: !Ref 'InternetGateway'
  PrivateSubnet1A:
    Condition: PrivateSubnet1ACondition
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref 'VPC'
      CidrBlock: !Ref 'PrivateSubnet1ACIDR'
      AvailabilityZone: !Select
        - '0'
        - !Ref 'AvailabilityZones'
      Tags:
        - Key: Name
          Value: Private subnet 1A
        - !If
          - PrivateSubnetTier1Tag1Condition
          - Key: !Select
              - '0'
              - !Split
                - '='
                - !Ref 'PrivateSubnetTier1Tag1'
            Value: !Select
              - '1'
              - !Split
                - '='
                - !Ref 'PrivateSubnetTier1Tag1'
          - !Ref 'AWS::NoValue'
        - !If
          - PrivateSubnetTier1Tag2Condition
          - Key: !Select
              - '0'
              - !Split
                - '='
                - !Ref 'PrivateSubnetTier1Tag2'
            Value: !Select
              - '1'
              - !Split
                - '='
                - !Ref 'PrivateSubnetTier1Tag2'
          - !Ref 'AWS::NoValue'
        - !If
          - PrivateSubnetTier1Tag3Condition
          - Key: !Select
              - '0'
              - !Split
                - '='
                - !Ref 'PrivateSubnetTier1Tag3'
            Value: !Select
              - '1'
              - !Split
                - '='
                - !Ref 'PrivateSubnetTier1Tag3'
          - !Ref 'AWS::NoValue'
  
  # More Resources ...

  PublicSubnet1:
    Condition: PublicSubnet1Condition
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref 'VPC'
      CidrBlock: !Ref 'PublicSubnet1CIDR'
      AvailabilityZone: !Select
        - '0'
        - !Ref 'AvailabilityZones'
      Tags:
        - Key: Name
          Value: Public subnet 1
        - !If
          - PublicSubnetTag1Condition
          - Key: !Select
              - '0'
              - !Split
                - '='
                - !Ref 'PublicSubnetTag1'
            Value: !Select
              - '1'
              - !Split
                - '='
                - !Ref 'PublicSubnetTag1'
          - !Ref 'AWS::NoValue'
        - !If
          - PublicSubnetTag2Condition
          - Key: !Select
              - '0'
              - !Split
                - '='
                - !Ref 'PublicSubnetTag2'
            Value: !Select
              - '1'
              - !Split
                - '='
                - !Ref 'PublicSubnetTag2'
          - !Ref 'AWS::NoValue'
        - !If
          - PublicSubnetTag3Condition
          - Key: !Select
              - '0'
              - !Split
                - '='
                - !Ref 'PublicSubnetTag3'
            Value: !Select
              - '1'
              - !Split
                - '='
                - !Ref 'PublicSubnetTag3'
          - !Ref 'AWS::NoValue'
      MapPublicIpOnLaunch: true
  
  # More Resources ...
Outputs:
  DefaultSG:
    Value: !GetAtt ["VPC", "DefaultSecurityGroup"]
    Description: VPC Default Security Group
    Export:
      Name: !Sub '${AWS::StackName}-DefaultSG'
  
  # More outputs. 
  VPCCIDR:
    Value: !Ref 'VPCCIDR'
    Description: VPC CIDR
    Export:
      Name: !Sub '${AWS::StackName}-VPCCIDR'
  VPCID:
    Value: !Ref 'VPC'
    Description: VPC ID
    Export:
      Name: !Sub '${AWS::StackName}-VPCID'
```

And I'll use a shell script like the following to create a VPC

```
#!/bin/bash
cd "$(dirname "$0")" && \
  source .dev.env && \
  STACK_NAME="$CORE_STACK_NAME-cloudmap-for-service-connect-$APPLICATION_NAME"

if [[ $1 = delete ]]
then 
  $AWS_CMD cloudformation "$1"-stack \
    --stack-name "$STACK_NAME" \
    $CF_ROLE_ARN_ARG \
    $CF_AWS_PROFILE \
    $AWS_REGION
else 
  $AWS_CMD cloudformation "$1"-stack \
    --stack-name $STACK_NAME \
    $CF_TEMPLATE_LOCATION/vpc-cf.yaml \
    $CF_ROLE_ARN_ARG \
    $CF_AWS_PROFILE \
    $AWS_REGION \
    --parameters \
      ParameterKey=AvailabilityZones,ParameterValue=eu-south-1a\\,eu-south-1b,UsePreviousValue=false \
      ParameterKey=CreateNATGatewayAZ1,ParameterValue=false,UsePreviousValue=false \
      ParameterKey=CreateNATGatewayAZ2,ParameterValue=false,UsePreviousValue=false \
      ParameterKey=CreateNATGatewayAZ3,ParameterValue=false,UsePreviousValue=false \
      ParameterKey=PrivateSubnet1ACIDR,ParameterValue=172.21.130.0/24,UsePreviousValue=false \
      ParameterKey=PrivateSubnet2ACIDR,ParameterValue=172.21.131.0/24,UsePreviousValue=false \
      ParameterKey=PrivateSubnet1BCIDR,ParameterValue=172.21.132.0/24,UsePreviousValue=false \
      ParameterKey=PrivateSubnet2BCIDR,ParameterValue=172.21.133.0/24,UsePreviousValue=false \
      ParameterKey=PublicSubnet1CIDR,ParameterValue=172.21.128.0/24,UsePreviousValue=false \
      ParameterKey=PublicSubnet2CIDR,ParameterValue=172.21.129.0/24,UsePreviousValue=false \
      ParameterKey=VPCCIDR,ParameterValue=172.21.128.0/20,UsePreviousValue=false \
      ParameterKey=VPCTenancy,ParameterValue=default,UsePreviousValue=false 
fi
```

Then, I can have another template that creates Secrutiy Groups and use that template as follows

```
#!/bin/bash
cd "$(dirname "$0")" && \
  source .dev.env && \
  STACK_NAME="$CORE_STACK_NAME"-sg-vpce-logs

if [[ $1 = delete ]]
then 
  cd "$(dirname "$0")" && \
  source .env && \
  $AWS_CMD cloudformation "$1"-stack \
    --stack-name "$STACK_NAME" \
    --region $AWS_REGION \
    $CF_AWS_PROFILE
else
  cd "$(dirname "$0")" && \
  source .env && \
  $AWS_CMD cloudformation "$1"-stack \
    --stack-name "$STACK_NAME" \
    --region $AWS_REGION \
    $CF_AWS_PROFILE \
    $CF_TEMPLATE_LOCATION/ec2-sg-cf.yaml \
    $CF_ROLE_ARN_ARG  \
    --parameters \
    ParameterKey=AllowIngressFromSelf,ParameterValue=true,UsePreviousValue=false \
    ParameterKey=VPCStackName,ParameterValue="$CORE_STACK_NAME"-vpc,UsePreviousValue=false
fi
```

In that example, the Security Group template uses the 'VPCStackName' parameter to do an FN::ImportValue on "!Ref VPCStackName"-"VPCID". 

If this all makes sense, create me the Bash script to create the Service Discovery stack that you have given me the template for.