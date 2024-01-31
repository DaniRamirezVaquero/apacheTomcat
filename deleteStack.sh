#!/bin/bash

# Script to delete the CloudFormation stack

STACK_NAME="Tomcat"
REGION="us-east-1"

echo "Deleting stack..."
aws cloudformation delete-stack --stack-name $STACK_NAME --region $REGION

echo "Waiting for stack to be deleted..."
aws cloudformation wait stack-delete-complete --stack-name $STACK_NAME --region $REGION

if [ $? -eq 0 ]; then
    echo "Deleting stack successfully"
fi


