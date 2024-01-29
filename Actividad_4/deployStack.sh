#!/bin/bash
# Script to deploy a CloudFormation template

STACK_NAME="Tomcat"
TEMPLATE_FILE="main.yml"
REGION="us-east-1"

echo "Deploying stack..."
aws cloudformation deploy --template-file "$TEMPLATE_FILE" --stack-name "$STACK_NAME" --region "$REGION"

echo "Waiting for stack to be deployed..."
aws cloudformation wait stack-create-complete --stack-name "$STACK_NAME" --region "$REGION"

echo "Stack deployed successfully"