#!/bin/bash

set -e

# Environment variables
POSTGRES_USER=${POSTGRES_USER:-postgres}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-}
POSTGRES_HOST=${POSTGRES_HOST:-localhost}
POSTGRES_PORT=${POSTGRES_PORT:-5432}
BACKUP_DIR=${BACKUP_DIR:-/backups}
AWS_BUCKET=${AWS_BUCKET:-my-s3-bucket}
AWS_REGION=${AWS_REGION:-us-east-1}
AWS_PROFILE=${AWS_PROFILE:-default}
ENV=${ENV:-development}
DATABASES=${POSTGRES_DATABASES:-}
SNS_TOPIC_ARN=${AWS_SNS_TOPIC_ARN}
DATE=$(date +%Y-%m-%d_%H-%M-%S)

# Ensure backup directory exists
mkdir -p $BACKUP_DIR

# Validate that DATABASES is set
if [ -z "$DATABASES" ]; then
    ERROR_MESSAGE="Error: POSTGRES_DATABASES is not set. Please specify databases as a comma-separated list."
    echo "$ERROR_MESSAGE"
    if [ -n "$SNS_TOPIC_ARN" ]; then
        /app/scripts/send_sns_notification.sh "$ERROR_MESSAGE" "PostgreSQL Backup Failure"
    fi
    exit 1
fi

# Track errors and successes
ERRORS=0
SUCCESSFUL_BACKUPS=()

# Perform backups for each database
IFS=',' read -ra DB_ARRAY <<< "$DATABASES"  # Split DATABASES into an array
for DATABASE in "${DB_ARRAY[@]}"; do
    BACKUP_FILE="$BACKUP_DIR/postgres_backup_${DATABASE}_$DATE.sql"
    S3_FOLDER="s3://$AWS_BUCKET/$ENV/$DATABASE/"
    echo "Backing up PostgreSQL database: $DATABASE on port $POSTGRES_PORT..."
    export PGPASSWORD=$POSTGRES_PASSWORD
    if pg_dump -U $POSTGRES_USER -h $POSTGRES_HOST -p $POSTGRES_PORT -d $DATABASE > $BACKUP_FILE; then
        echo "Backup saved to $BACKUP_FILE"

        # Upload backup to S3
        echo "Uploading $BACKUP_FILE to S3 folder $S3_FOLDER..."
        if aws s3 cp "$BACKUP_FILE" "$S3_FOLDER" --region $AWS_REGION --profile $AWS_PROFILE; then
            echo "Backup for $DATABASE uploaded successfully to S3 folder $S3_FOLDER."
            SUCCESSFUL_BACKUPS+=("$DATABASE")  # Add to success list
        else
            ERROR_MESSAGE="Error: Failed to upload backup for $DATABASE to S3."
            echo "$ERROR_MESSAGE"
            ERRORS=1
            if [ -n "$SNS_TOPIC_ARN" ]; then
                /app/scripts/send_sns_notification.sh "$ERROR_MESSAGE" "PostgreSQL Backup Failure"
            fi
            exit 1
        fi
    else
        ERROR_MESSAGE="Backup failed for database: $DATABASE"
        echo "$ERROR_MESSAGE"
        ERRORS=1
        if [ -n "$SNS_TOPIC_ARN" ]; then
            /app/scripts/send_sns_notification.sh "$ERROR_MESSAGE" "PostgreSQL Backup Failure"
        fi
        exit 1
    fi
done

# Final success notification
if [ "$ERRORS" -eq 0 ]; then
    SUCCESS_MESSAGE="All PostgreSQL backups completed successfully and uploaded to S3. Databases backed up: ${SUCCESSFUL_BACKUPS[*]}."
    echo "$SUCCESS_MESSAGE"
    if [ -n "$SNS_TOPIC_ARN" ]; then
        /app/scripts/send_sns_notification.sh "$SUCCESS_MESSAGE" "PostgreSQL Backup Success"
    fi
else
    echo "There were errors in the backup or upload process."
    exit 1
fi