# Base image
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Install necessary tools, including the desired version of PostgreSQL
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg \
    lsb-release \
    && curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && apt-get update && apt-get install -y \
    postgresql-client-16 \
    awscli \
    bash \
    tar \
    && apt-get clean

# Set working directory
WORKDIR /app

# Copy scripts into the container
COPY scripts/ /app/scripts/

# Ensure scripts are executable
RUN chmod +x /app/scripts/*.sh

# Default command
CMD ["bash"]