#!/bin/bash

set -e

# Environment variables
MYSQL_USER=${MYSQL_USER:-root}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-}
MYSQL_HOST=${MYSQL_HOST:-localhost}
BACKUP_DIR=${BACKUP_DIR:-/backups}
SNS_TOPIC_ARN=${AWS_SNS_TOPIC_ARN}
AWS_REGION=${AWS_REGION:-us-east-1}
DATE=$(date +%Y-%m-%d_%H-%M-%S)

mkdir -p $BACKUP_DIR
BACKUP_FILE="$BACKUP_DIR/mysql_backup_$DATE.sql"

echo "Backing up MySQL database..."
if mysqldump -u$MYSQL_USER -p$MYSQL_PASSWORD -h$MYSQL_HOST --all-databases > $BACKUP_FILE; then
    echo "Backup saved to $BACKUP_FILE"
    
    # Send success notification to SNS
    if [ -n "$SNS_TOPIC_ARN" ]; then
        /app/scripts/send_sns_notification.sh \
            "MySQL backup completed successfully: $BACKUP_FILE" \
            "MySQL Backup Success"
    else
        echo "SNS_TOPIC_ARN is not set. Skipping SNS notification."
    fi
else
    echo "MySQL backup failed."

    # Send failure notification to SNS
    if [ -n "$SNS_TOPIC_ARN" ]; then
        /app/scripts/send_sns_notification.sh \
            "MySQL backup failed." \
            "MySQL Backup Failure"
    else
        echo "SNS_TOPIC_ARN is not set. Skipping SNS notification."
    fi

    exit 1
fi