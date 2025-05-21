#!/bin/bash

# crontab
# 0 0 * * * /path/check_yao_amis_update.sh --check-update

# Configuration
IMAGE_NAME="wwsheng009/yao-amis-admin-amd64:latest"
COMPOSE_FILE="docker-compose-mariadb.yml"
LOG_FILE="/var/log/yao_amis_update.log"
ENV_FILE=".env"
ENV_TEMPLATE=".env.mysql"
export COMPOSE_PROJECT_NAME=yao-demo

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to notify admin
notify_admin() {
    echo "ERROR: $1" # | mail -s "Yao Update Failure" wwsheng@qq.com
}

# Function to check if .env file exists
check_env_file() {
    if [ ! -f "$ENV_FILE" ]; then
        log_message "ERROR: Environment file $ENV_FILE not found."
        echo "Environment file $ENV_FILE is missing."
        if [ -f "$ENV_TEMPLATE" ]; then
            echo "A template file ($ENV_TEMPLATE) is available."
            read -p "Would you like to copy $ENV_TEMPLATE to $ENV_FILE? (y/n): " response
            if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
                cp "$ENV_TEMPLATE" "$ENV_FILE"
                if [ $? -eq 0 ]; then
                    log_message "Copied $ENV_TEMPLATE to $ENV_FILE successfully."
                    echo "Created $ENV_FILE. Please review and edit it as needed."
                else
                    log_message "ERROR: Failed to copy $ENV_TEMPLATE to $ENV_FILE."
                    notify_admin "Failed to copy $ENV_TEMPLATE to $ENV_FILE"
                    exit 1
                fi
            else
                log_message "User chose not to copy $ENV_TEMPLATE. Prompting to create $ENV_FILE."
                echo "Please create $ENV_FILE manually and configure the necessary environment variables."
                exit 1
            fi
        else
            log_message "ERROR: Template file $ENV_TEMPLATE not found."
            echo "Template file $ENV_TEMPLATE not found. Please create $ENV_FILE manually."
            notify_admin "Environment file $ENV_FILE and template $ENV_TEMPLATE not found"
            exit 1
        fi
    fi
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

# Function to start containers
start_containers() {
    log_message "Starting containers..."
    check_compose_file
    check_env_file
    docker-compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" up -d
    if [ $? -ne 0 ]; then
        log_message "ERROR: Failed to start containers."
        notify_admin "Failed to start containers"
        exit 1
    fi
    verify_container_health
    log_message "Containers started successfully."
}

# Function to stop containers
stop_containers() {
    log_message "Stopping and removing existing containers..."
    check_compose_file
    check_env_file
    docker-compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" down
    if [ $? -ne 0 ]; then
        log_message "ERROR: Failed to stop containers."
        notify_admin "Failed to stop containers"
        exit 1
    fi
    log_message "Containers stopped and removed successfully."
}

# Function to check for updates
check_update() {
    log_message "Checking for image updates for $IMAGE_NAME..."
    check_compose_file
    LOCAL_DIGEST=$(get_local_digest)
    REMOTE_DIGEST=$(get_remote_digest)
    if [ -z "$LOCAL_DIGEST" ]; then
        log_message "No local image found. Update is available."
        return 1
    elif [ "$LOCAL_DIGEST" != "$REMOTE_DIGEST" ]; then
        log_message "Update detected. Local digest: $LOCAL_DIGEST, Remote digest: $REMOTE_DIGEST"
        return 1
    else
        log_message "No update available. Local digest matches remote digest."
        return 0
    fi
}

# Function to update containers
update_containers() {
    log_message "Stopping and removing existing containers..."
    check_env_file
    docker-compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" down
    if [ $? -ne 0 ]; then
        log_message "ERROR: Failed to stop containers."
        notify_admin "Failed to stop containers"
        exit 1
    fi

    log_message "Pulling latest images..."
    docker-compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" pull
    if [ $? -ne 0 ]; then
        log_message "ERROR: Failed to pull latest images."
        notify_admin "Failed to pull latest images"
        exit 1
    fi

    log_message "Starting containers with updated image..."
    docker-compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" up -d
    if [ $? -ne 0 ]; then
        log_message "ERROR: Failed to start containers."
        notify_admin "Failed to start containers"
        exit 1
    fi

    verify_container_health
    log_message "Containers updated and restarted successfully."
}

# Function to display menu and get user input
display_menu() {
    echo "Please select an option:"
    echo "1) Start containers"
    echo "2) Stop containers"
    echo "3) Check for updates"
    echo "4) Update containers"
    echo "5) Exit"
    read -p "Enter your choice (1-5): " choice
    case $choice in
        1) start_containers ;;
        2) stop_containers ;;
        3) check_update ;;
        4) check_update && update_containers ;;
        5) log_message "Exiting script." ; exit 0 ;;
        *) echo "Invalid option. Please select 1-5." ; display_menu ;;
    esac
}

# Main execution
if [ $# -eq 1 ]; then
    case $1 in
        --start)
            log_message "Starting image update check for $IMAGE_NAME"
            start_containers
            ;;
        --stop)
            log_message "Stopping containers for $IMAGE_NAME"
            stop_containers
            ;;
        --check-update)
            log_message "Starting image update check for $IMAGE_NAME"
            check_update
            if [ $? -eq 1 ]; then
                update_containers
            fi
            ;;
        *)
            echo "Usage: $0 [--start | --stop | --check-update]"
            exit 1
            ;;
    esac
else
    log_message "Starting interactive mode for $IMAGE_NAME"
    display_menu
fi