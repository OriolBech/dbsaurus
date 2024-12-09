#!/bin/bash

set -e

# Environment variables
POSTGRES_USER=${POSTGRES_USER:-postgres}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-}
POSTGRES_HOST=${POSTGRES_HOST:-localhost}
POSTGRES_DB=${POSTGRES_DB:-postgres}
BACKUP_DIR=${BACKUP_DIR:-/backups}
SNS_TOPIC_ARN=${AWS_SNS_TOPIC_ARN}
AWS_REGION=${AWS_REGION:-us-east-1}
DATE=$(date +%Y-%m-%d_%H-%M-%S)

mkdir -p $BACKUP_DIR
BACKUP_FILE="$BACKUP_DIR/postgres_backup_$DATE.sql"

echo "Backing up PostgreSQL database..."
export PGPASSWORD=$POSTGRES_PASSWORD

if pg_dump -U $POSTGRES_USER -h $POSTGRES_HOST -d $POSTGRES_DB > $BACKUP_FILE; then
    echo "Backup saved to $BACKUP_FILE"
    
    # Send success notification to SNS
    if [ -n "$SNS_TOPIC_ARN" ]; then
        /app/scripts/send_sns_notification.sh \
            "PostgreSQL backup completed successfully: $BACKUP_FILE" \
            "PostgreSQL Backup Success"
    else
        echo "SNS_TOPIC_ARN is not set. Skipping SNS notification."
    fi
else
    echo "PostgreSQL backup failed."

    # Send failure notification to SNS
    if [ -n "$SNS_TOPIC_ARN" ]; then
        /app/scripts/send_sns_notification.sh \
            "PostgreSQL backup failed." \
            "PostgreSQL Backup Failure"
    else
        echo "SNS_TOPIC_ARN is not set. Skipping SNS notification."
    fi

    exit 1
fi