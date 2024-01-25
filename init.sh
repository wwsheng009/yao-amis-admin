#!/bin/bash
# Path to the .env file
ENV_FILE=".env"

# Check if the .env file exists
if [ -f "$ENV_FILE" ]; then
    echo ".env file found. Running 'yao migrate'..."
    # Run yao migrate
    /usr/local/bin/yao migrate
fi


/usr/local/bin/yao start