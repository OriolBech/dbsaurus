# Database Backup to S3

This project provides a modular and standardized way to back up MySQL or PostgreSQL databases and upload them to an S3 bucket using Docker.

## Features
- Modular design for MySQL and PostgreSQL backups.
- Secure upload to AWS S3.
- Fully configurable via environment variables.

## Quick Start
1. Clone the repository.
2. Create a `.env` file based on `.env.example`.
3. Build the Docker image:
   ```bash
   docker build -t database-backup .
4. Use de image:
   docker run --rm \
    -v /path/to/local/backups:/backups \
    --env-file /path/to/.env \
    database-backup \
    bash /app/scripts/backup_postgresql.sh

