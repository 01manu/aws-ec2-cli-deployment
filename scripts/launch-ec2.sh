#!/bin/bash

KEY_NAME="MyKeyPair"
SG_NAME="my-sg"
INSTANCE_TYPE="t3.micro"

echo "Fetching default VPC ID..."
VPC_ID=$(aws ec2 describe-vpcs --filters Name=isDefault,Values=true --query "Vpcs[0].VpcId" --output text)

echo "Fetching security group ID..."
SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=$SG_NAME Name=vpc-id,Values=$VPC_ID --query "SecurityGroups[0].GroupId" --output text)

echo "Fetching latest Amazon Linux 2023 AMI..."
AMI_ID=$(aws ssm get-parameter --name /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 --query Parameter.Value --output text)

echo "Launching EC2 instance..."
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --instance-type $INSTANCE_TYPE \
  --key-name $KEY_NAME \
  --security-group-ids $SG_ID \
  --count 1 \
  --query "Instances[0].InstanceId" \
  --output text)

echo "EC2 Instance launched: $INSTANCE_ID "

echo "Get public IP:"
aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text
