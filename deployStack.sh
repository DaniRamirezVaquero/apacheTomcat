#!/bin/bash
# Script to deploy a CloudFormation template

STACK_NAME="Tomcat"
TEMPLATE_FILE="ubuntu.yml"
REGION="us-east-1"

echo "Deploying stack..."
aws cloudformation deploy --template-file "$TEMPLATE_FILE" --stack-name "$STACK_NAME" --region "$REGION"

if [ $? -eq 0 ]; then
    echo "Stack deployed successfully"
    PUBLIC_IP=$(aws cloudformation list-exports \
        --query "Exports[?Name=='${STACK_NAME}Instance-PublicIP'].Value" --output text)

    URL="http://$PUBLIC_IP:8080"

    echo "--------------------------------------"
    echo "IP: $PUBLIC_IP"
    echo "URL: $URL"
    echo "--------------------------------------"
fi