#!/bin/bash
# Script to deploy a CloudFormation template

STACK_NAME="Tomcat"
TEMPLATE_FILE="main.yml"
REGION="us-east-1"

aws cloudformation deploy --template-file "$TEMPLATE_FILE" --stack-name "$STACK_NAME" --region "$REGION"
