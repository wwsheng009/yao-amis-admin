#!/bin/bash

# 定义标记文件路径
INIT_MARKER="/var/run/yao-init-completed"

# 检查是否已经初始化过
if [ ! -f "$INIT_MARKER" ]; then
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

    # 创建标记文件，表示初始化已完成
    touch "$INIT_MARKER"
    echo "Initialization completed and marked."
else
    echo "Initialization already completed, skipping..."
fi

/usr/local/bin/yao start