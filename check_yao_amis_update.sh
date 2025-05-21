#!/bin/bash

# crontab
# 0 0 * * * /path/check_yao_amis_update.sh

# Configuration
IMAGE_NAME="wwsheng009/yao-amis-admin-amd64:latest"
COMPOSE_FILE="docker-compose-mariadb.yml"
LOG_FILE="/var/log/yao_amis_update.log"
export COMPOSE_PROJECT_NAME=yao-demo

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to notify admin
notify_admin() {
    echo "ERROR: $1" | mail -s "Yao Update Failure" admin@example.com
}

# Function to check if Docker Compose file exists
check_compose_file() {
    if [ ! -f "$COMPOSE_FILE" ]; then
        log_message "ERROR: Docker Compose file $COMPOSE_FILE not found."
        notify_admin "Docker Compose file not found"
        exit 1
    fi
}

# Function to get the local image digest
get_local_digest() {
    docker inspect --format='{{.RepoDigests}}' "$IMAGE_NAME" 2>/dev/null | grep -o 'sha256:[a-f0-9]\{64\}' || echo ""
}

# Function to get the latest image digest from registry
get_remote_digest() {
    for i in {1..3}; do
        docker pull "$IMAGE_NAME" --quiet >/dev/null 2>&1 && break
        log_message "WARNING: Pull attempt $i failed. Retrying..."
        sleep 5
    done
    if [ $? -ne 0 ]; then
        log_message "ERROR: Failed to pull $IMAGE_NAME after 3 attempts."
        notify_admin "Failed to pull $IMAGE_NAME"
        exit 1
    fi
    docker inspect --format='{{.RepoDigests}}' "$IMAGE_NAME" | grep -o 'sha256:[a-f0-9]\{64\}'
}

# Function to verify container health
verify_container_health() {
    log_message "Verifying container health..."
    for i in {1..6}; do
        if docker-compose -f "$COMPOSE_FILE" ps | grep -q "healthy"; then
            log_message "All containers are healthy."
            return 0
        fi
        log_message "Waiting for containers to become healthy (attempt $i)..."
        sleep 10
    done
    log_message "ERROR: Containers failed to become healthy."
    notify_admin "Containers failed to become healthy"
    exit 1
}

# Function to update containers
update_containers() {
    log_message "Stopping and removing existing containers..."
    docker-compose --env-file .env -f "$COMPOSE_FILE" down
    if [ $? -ne 0 ]; then
        log_message "ERROR: Failed to stop containers."
        notify_admin "Failed to stop containers"
        exit 1
    fi

    log_message "Pulling latest images..."
    docker-compose --env-file .env -f "$COMPOSE_FILE" pull
    if [ $? -ne 0 ]; then
        log_message "ERROR: Failed to pull latest images."
        notify_admin "Failed to pull latest images"
        exit 1
    fi

    log_message "Starting containers with updated image..."
    docker-compose --env-file .env -f "$COMPOSE_FILE" up -d
    if [ $? -ne 0 ]; then
        log_message "ERROR: Failed to start containers."
        notify_admin "Failed to start containers"
        exit 1
    fi

    verify_container_health
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