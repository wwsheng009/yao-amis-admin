#!/bin/bash

set -e

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# 错误日志函数
log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" >&2
}

# 安装插件函数
install_plugins() {
    local ARCH=$1
    log "开始安装插件，架构: ${ARCH}"

    # 创建插件目录
    log "创建插件目录"
    mkdir -p plugins

    # 下载并安装amis-editor
    log "开始下载并安装amis-editor"
    mkdir -p public/amis-editor
    rm -rf public/amis-editor/*
    log "下载amis-editor包"
    echo "正在下载amis-editor包..."
    curl -# -fL "https://github.com/wwsheng009/amis-editor-yao/releases/download/1.1.4/amis-editor-1.1.4.zip" -o public/amis-editor/latest.zip || { log_error "下载amis-editor失败"; exit 1; }
    log "解压amis-editor包"
    unzip -q public/amis-editor/latest.zip -d public/amis-editor/
    rm public/amis-editor/latest.zip

    # 下载并安装soy-admin
    log "开始下载并安装soy-admin"
    mkdir -p public/soy-admin
    rm -rf public/soy-admin/*
    log "下载soy-admin包"
    echo "正在下载soy-admin包..."
    curl -# -fL "https://github.com/wwsheng009/soybean-admin-amis-yao/releases/download/1.3.14/soy-yao-admin.zip" -o public/soy-admin/latest.zip || { log_error "下载soy-admin失败"; exit 1; }
    log "解压soy-admin包"
    unzip -q public/soy-admin/latest.zip -d public/soy-admin/
    rm public/soy-admin/latest.zip

    # replace the /publice/soy-admin/index.html file 
    # /soy-admin/amis/jssdk => /amis-admin/jssdk
    # 替换 soy-admin 的 index.html 文件中的路径
    log "替换 soy-admin 的路径配置"
    if [[ "$OS_TYPE" == "windows" ]]; then
        powershell -Command "(Get-Content public/soy-admin/index.html) -replace '/soy-admin/amis/jssdk', '/amis-admin/jssdk' | Set-Content public/soy-admin/index.html"
        powershell -Command "(Get-Content public/soy-admin/index.html) -replace '/amis/jssdk', '/amis-admin/jssdk' | Set-Content public/soy-admin/index.html"
    else
        sed -i 's|/soy-admin/amis/jssdk|/amis-admin/jssdk|g' public/soy-admin/index.html
        sed -i 's|/amis/jssdk|/amis-admin/jssdk|g' public/soy-admin/index.html
    fi

    # 下载插件
    log "开始下载插件"
    rm -rf plugins/psutil.*
    rm -rf plugins/command.*
    rm -rf plugins/email.*
    if [[ "$OS_TYPE" == "windows" ]]; then
        log "下载Windows版本插件 (${ARCH})"
        echo "正在下载command插件..."
        curl -# -fL "https://github.com/wwsheng009/yao-plugin-command/releases/download/yao-command-plugin/command-windows-${ARCH}.dll" -o plugins/command.dll || { log_error "下载command插件失败"; exit 1; }
        echo "正在下载psutil插件..."
        curl -# -fL "https://github.com/wwsheng009/yao-plugin-psutil/releases/download/yao-psutil-plugin/psutil-windows-${ARCH}.dll" -o plugins/psutil.dll || { log_error "下载psutil插件失败"; exit 1; }
        echo "正在下载email插件..."
        curl -# -fL "https://github.com/wwsheng009/yao-plugin-email/releases/download/yao-email-plugin/email-windows-${ARCH}.dll" -o plugins/email.dll || { log_error "下载email插件失败"; exit 1; }
    else
        log "下载Linux版本插件 (${ARCH})"
        echo "正在下载command插件..."
        curl -# -fL "https://github.com/wwsheng009/yao-plugin-command/releases/download/yao-command-plugin/command-linux-${ARCH}.so" -o plugins/command.so || { log_error "下载command插件失败"; exit 1; }
        echo "正在下载psutil插件..."
        curl -# -fL "https://github.com/wwsheng009/yao-plugin-psutil/releases/download/yao-psutil-plugin/psutil-linux-${ARCH}.so" -o plugins/psutil.so || { log_error "下载psutil插件失败"; exit 1; }
        echo "正在下载email插件..."
        curl -# -fL "https://github.com/wwsheng009/yao-plugin-email/releases/download/yao-email-plugin/email-linux-${ARCH}.so" -o plugins/email.so || { log_error "下载email插件失败"; exit 1; }

        # 设置执行权限（仅Linux）
        log "设置Linux插件执行权限"
        chmod +x plugins/*.so
    fi
    log "插件安装完成"
}

# 系统和架构自动检测
log "开始系统和架构检测"
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    OS_TYPE="windows"
    log "检测到Windows系统"
    # Windows下使用PowerShell获取架构信息
    PROCESSOR_ARCH=$(powershell -Command "[System.Environment]::GetEnvironmentVariable('PROCESSOR_ARCHITECTURE')")
    case "$PROCESSOR_ARCH" in
        AMD64)
            DEFAULT_ARCH="amd64"
            ;;
        ARM64)
            DEFAULT_ARCH="arm64"
            ;;
        32-bit) DEFAULT_ARCH="386" ;;
        *) echo "不支持的架构: $DETECTED_ARCH"; exit 1 ;;
    esac
else
    OS_TYPE="linux"
    log "检测到Linux系统"
    DETECTED_ARCH=$(uname -m)
    case "$DETECTED_ARCH" in
        x86_64) DEFAULT_ARCH="amd64"; log "检测到x86_64架构" ;;
        aarch64) DEFAULT_ARCH="arm64"; log "检测到ARM64架构" ;;
        *) log_error "不支持的架构: $DETECTED_ARCH"; exit 1 ;;
    esac
fi

# 主执行逻辑
log "开始执行插件安装"
if [ -n "$1" ]; then
    log "使用指定的架构: $1"
    install_plugins "$1"
elif [ -n "$DEFAULT_ARCH" ]; then
    log "使用自动检测的架构: $DEFAULT_ARCH"
    install_plugins "$DEFAULT_ARCH"
else
    log_error "未指定架构且自动检测失败"
    echo "Usage: $0 <ARCH>"
    exit 1
fi

log "脚本执行完成"