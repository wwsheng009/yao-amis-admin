#!/bin/bash

set -e

# 安装插件函数
install_plugins() {
    local ARCH=$1

    # 创建插件目录
    mkdir -p plugins

    # 下载并安装amis-editor
    mkdir -p public/amis-editor
    curl -fsSL "https://github.com/wwsheng009/amis-editor-yao/releases/download/1.1.0/amis-editor-1.1.0.zip" -o public/amis-editor/latest.zip
    unzip -q public/amis-editor/latest.zip -d public/amis-editor/
    rm public/amis-editor/latest.zip

    # 下载并安装soy-admin
    mkdir -p public/soy-admin
    curl -fsSL "https://github.com/wwsheng009/soybean-admin-amis-yao/releases/download/0.10.4/soy-yao-admin-0.10.4.zip" -o public/soy-admin/latest.zip
    unzip -q public/soy-admin/latest.zip -d public/soy-admin/
    rm public/soy-admin/latest.zip

    # 下载插件
    curl -fsSL "https://github.com/wwsheng009/yao-plugin-command/releases/download/command-linux-plugin/command-linux-${ARCH}.so" -o plugins/command.so
    curl -fsSL "https://github.com/wwsheng009/yao-plugin-psutil/releases/download/psutil-linux-plugin/psutil-linux-${ARCH}.so" -o plugins/psutil.so
    curl -fsSL "https://github.com/wwsheng009/yao-plugin-email/releases/download/email-linux-plugin/email-linux-${ARCH}.so" -o plugins/email.so

    # 设置执行权限
    chmod +x plugins/*.so
}

# 架构自动检测
DETECTED_ARCH=$(uname -m)
case "$DETECTED_ARCH" in
    x86_64) DEFAULT_ARCH="amd64" ;;
    aarch64) DEFAULT_ARCH="arm64" ;;
    *) echo "不支持的架构: $DETECTED_ARCH"; exit 1 ;;
esac

# 主执行逻辑
if [ -n "$1" ]; then
    install_plugins "$1"
elif [ -n "$DEFAULT_ARCH" ]; then
    echo "使用自动检测的架构: $DEFAULT_ARCH"
    install_plugins "$DEFAULT_ARCH"
else
    echo "Usage: $0 <ARCH>"
    exit 1
fi