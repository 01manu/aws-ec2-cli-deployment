#!/bin/bash

SG_NAME="my-sg"
DESCRIPTION="Security group for EC2 CLI project"

echo "Fetching default VPC ID..."

VPC_ID=$(aws ec2 describe-vpcs \
  --filters Name=isDefault,Values=true \
  --query "Vpcs[0].VpcId" \
  --output text)

echo "Default VPC: $VPC_ID"

echo "Checking if security group exists..."

SG_ID=$(aws ec2 describe-security-groups \
  --filters Name=group-name,Values=$SG_NAME Name=vpc-id,Values=$VPC_ID \
  --query "SecurityGroups[0].GroupId" \
  --output text)

if [ "$SG_ID" != "None" ]; then
  echo "Security group '$SG_NAME' already exists: $SG_ID ✅"
  exit 0
fi

echo "Creating security group..."

SG_ID=$(aws ec2 create-security-group \
  --group-name $SG_NAME \
  --description "$DESCRIPTION" \
  --vpc-id $VPC_ID \
  --query "GroupId" \
  --output text)

echo "Security group created: $SG_ID"

# Allow SSH (replace with your IP)
aws ec2 authorize-security-group-ingress \
  --group-id $SG_ID \
  --protocol tcp \
  --port 22 \
  --cidr 176.0.27.96/32


# Allow HTTP
aws ec2 authorize-security-group-ingress \
  --group-id $SG_ID \
  --protocol tcp \
  --port 80 \
  --cidr 0.0.0.0/0

echo "Ingress rules added ✅"
