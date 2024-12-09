#!/bin/bash

set -e

# Variables de entorno
SNS_TOPIC_ARN=${AWS_SNS_TOPIC_ARN}
AWS_REGION=${AWS_REGION:-us-east-1}
MESSAGE=$1
ENV=${ENV}
SUBJECT=${2:-"Backup Notification ($ENV)"}

if [ -z "$SNS_TOPIC_ARN" ]; then
    echo "Error: AWS_SNS_TOPIC_ARN is not set."
    exit 1
fi

if [ -z "$MESSAGE" ]; then
    echo "Error: Message is required."
    exit 1
fi

# Send sns message
aws sns publish \
    --topic-arn "$SNS_TOPIC_ARN" \
    --message "$MESSAGE" \
    --subject "$SUBJECT" \
    --region "$AWS_REGION"

echo "Message sent to SNS topic: $SNS_TOPIC_ARN"