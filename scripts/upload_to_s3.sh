#!/bin/bash

set -e

# Environment variables
AWS_BUCKET=${AWS_BUCKET:-my-s3-bucket}
BACKUP_DIR=${BACKUP_DIR:-/backups}
AWS_REGION=${AWS_REGION:-us-east-1}

# Check if AWS_BUCKET is set
if [ -z "$AWS_BUCKET" ]; then
    echo "Error: AWS_BUCKET is not set. Please provide a valid S3 bucket name."
    exit 1
fi

# Check if BACKUP_DIR exists and is not empty
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Error: Backup directory $BACKUP_DIR does not exist."
    exit 1
fi

if [ -z "$(ls -A $BACKUP_DIR)" ]; then
    echo "Error: Backup directory $BACKUP_DIR is empty. Nothing to upload."
    exit 1
fi

# Attempt to upload files to S3
echo "Uploading backups from $BACKUP_DIR to S3 bucket $AWS_BUCKET in region $AWS_REGION..."
if aws s3 cp $BACKUP_DIR s3://$AWS_BUCKET/ --recursive --region $AWS_REGION; then
    echo "Backup upload completed successfully."
else
    echo "Error: Backup upload to S3 bucket $AWS_BUCKET failed."
    exit 1
fi