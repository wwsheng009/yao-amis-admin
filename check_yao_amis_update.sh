#!/bin/bash

# 0 * * * * /path/check_yao_amis_update.sh

# Configuration
IMAGE_NAME="wwsheng009/yao-amis-admin-amd64:latest"
COMPOSE_FILE="docker-compose-mariadb.yml"
LOG_FILE="/var/log/yao_amis_update.log"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to check if Docker Compose file exists
check_compose_file() {
    if [ ! -f "$COMPOSE_FILE" ]; then
        log_message "ERROR: Docker Compose file $COMPOSE_FILE not found."
        exit 1
    fi
}

# Function to get the local image digest
get_local_digest() {
    docker inspect --format='{{.RepoDigests}}' "$IMAGE_NAME" 2>/dev/null | grep -o 'sha256:[a-f0-9]\{64\}' || echo ""
}

# Function to get the latest image digest from registry
get_remote_digest() {
    docker pull "$IMAGE_NAME" --quiet >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        log_message "ERROR: Failed to pull $IMAGE_NAME."
        exit 1
    fi
    docker inspect --format='{{.RepoDigests}}' "$IMAGE_NAME" | grep -o 'sha256:[a-f0-9]\{64\}'
}

# Function to update containers
update_containers() {
    log_message "Stopping and removing existing containers..."
    docker-compose -f "$COMPOSE_FILE" down
    if [ $? -ne 0 ]; then
        log_message "ERROR: Failed to stop containers."
        exit 1
    fi

    log_message "Pulling latest images..."
    docker-compose -f "$COMPOSE_FILE" pull
    if [ $? -ne 0 ]; then
        log_message "ERROR: Failed to pull latest images."
        exit 1
    fi

    log_message "Starting containers with updated image..."
    docker-compose -f "$COMPOSE_FILE" up -d
    if [ $? -ne 0 ]; then
        log_message "ERROR: Failed to start containers."
        exit 1
    fi
    log_message "Containers updated and restarted successfully."
}

# Main execution
log_message "Starting image update check for $IMAGE_NAME"

# Ensure Docker Compose file exists
check_compose_file

# Get local and remote digests
LOCAL_DIGEST=$(get_local_digest)
REMOTE_DIGEST=$(get_remote_digest)

if [ -z "$LOCAL_DIGEST" ]; then
    log_message "No local image found. Pulling and starting containers..."
    update_containers
elif [ "$LOCAL_DIGEST" != "$REMOTE_DIGEST" ]; then
    log_message "Update detected. Local digest: $LOCAL_DIGEST, Remote digest: $REMOTE_DIGEST"
    update_containers
else
    log_message "No update available. Local digest matches remote digest."
fi