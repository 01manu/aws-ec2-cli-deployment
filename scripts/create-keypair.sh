#!/bin/bash

KEY_NAME="MyKeyPair"

echo "Checking if key pair exists..."

aws ec2 describe-key-pairs --key-names "$KEY_NAME" > /dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "Key pair '$KEY_NAME' already exists "
else
  echo "Creating key pair '$KEY_NAME'..."

  aws ec2 create-key-pair \
    --key-name "$KEY_NAME" \
    --query "KeyMaterial" \
    --output text > "$KEY_NAME.pem"

  chmod 400 "$KEY_NAME.pem"

  echo "Key pair created and saved as $KEY_NAME.pem "
fi
