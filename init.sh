#!/bin/bash

# Remount /etc to allow writing to resolv.conf
# mount -o remount,rw /etc

# Write DNS servers to resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 8.8.8.4" >> /etc/resolv.conf
echo "nameserver 2001:4860:4860::8888" >> /etc/resolv.conf
echo "nameserver 2001:4860:4860::8844" >> /etc/resolv.conf

# Remount back to read-only if you want
# mount -o remount,ro /etc

# Path to the .env file
ENV_FILE=".env"

# Check if the .env file exists
if [ -f "$ENV_FILE" ]; then
    echo ".env file found. Running 'yao migrate'..."
    # Run yao migrate
    /usr/local/bin/yao migrate
fi


/usr/local/bin/yao start