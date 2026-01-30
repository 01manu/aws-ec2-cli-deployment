#!/bin/bash

echo "Checking AWS CLI configuration..."

aws sts get-caller-identity

if [ $? -eq 0 ]; then
  echo "AWS CLI is configured correctly "
else
  echo "AWS CLI is NOT configured "
fi
