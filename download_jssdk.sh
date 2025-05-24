#!/bin/bash

set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to get the latest release tag
get_latest_release() {
    local repo_url="https://api.github.com/repos/baidu/amis/releases/latest"
    if command_exists curl; then
        curl -s "$repo_url" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
    else
        wget -qO- "$repo_url" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
    fi
}

# Get the latest release tag
latest_tag=$(get_latest_release)
if [ -z "$latest_tag" ]; then
    echo "Failed to retrieve the latest release tag."
    exit 1
fi

# Fetch the release page and grep for .tar.gz files
if command_exists curl; then
    assets_page=$(curl -s "https://api.github.com/repos/baidu/amis/releases/tags/$latest_tag")
    download_url=$(echo "$assets_page" | grep -o '"browser_download_url": *"[^"]*\.tar\.gz"' | sed -e 's/"browser_download_url": *"//' -e 's/"$//' | head -n 1)
else
    assets_page=$(wget -qO- "https://api.github.com/repos/baidu/amis/releases/tags/$latest_tag")
    download_url=$(echo "$assets_page" | grep -o '"browser_download_url": *"[^"]*\.tar\.gz"' | sed -e 's/"browser_download_url": *"//' -e 's/"$//' | head -n 1)
fi

if [ -z "$download_url" ]; then
    echo "No .tar.gz file found in the latest release."
    exit 1
fi

# Download the tar.gz file
echo "Downloading $download_url"
if command_exists curl; then
    curl -L -o latest_jssdk.tar.gz "$download_url"
else
    wget -O latest_jssdk.tar.gz "$download_url"
fi

if [ $? -ne 0 ]; then
    echo "Failed to download the .tar.gz file"
    exit 1
fi

# Remove the existing folder before extraction
echo "Removing existing public/amis-admin/jssdk folder"
rm -rf public/amis-admin/jssdk

# Ensure the target directory exists (it will be recreated by tar)
mkdir -p public/amis-admin/jssdk

# Extract the downloaded tar.gz file
echo "Extracting latest_jssdk.tar.gz to public/amis-admin/jssdk"
tar -xzf latest_jssdk.tar.gz -C public/amis-admin/jssdk

if [ $? -ne 0 ]; then
    echo "Failed to extract latest_jssdk.tar.gz"
    rm latest_jssdk.tar.gz
    exit 1
fi

# Remove files with prefix "._" in the extraction directory and its subdirectories
echo "Removing files with prefix '._' in the extracted directory"
find public/amis-admin/jssdk -type f -name "._*" -delete

# Clean up the downloaded file
rm latest_jssdk.tar.gz

echo "Successfully downloaded, extracted, cleaned, and updated public/amis-admin/jssdk"


mkdir -p public/amis-admin/scripts/lib

# download js library
# Function to download file to local
downloadLibrary() {
    local source="$1"
    local target="$2"
    
    echo "Downloading $source to $target..."

    if command -v curl &> /dev/null; then
        curl -L -o "public/amis-admin/scripts/lib/$target" "$source"
        if [ $? -eq 0 ]; then
            echo "Successfully downloaded $target using curl."
        else
            echo "Failed to download $target using curl."
            return 1
        fi
    elif command -v wget &> /dev/null; then
        wget -O "public/amis-admin/scripts/lib/$target" "$source"
        if [ $? -eq 0 ]; then
            echo "Successfully downloaded $target using wget."
        else
            echo "Failed to download $target using wget."
            return 1
        fi
    else
        echo "Neither curl nor wget is available. Cannot download the file."
        return 1
    fi
}

echo "Current directory: $(pwd)"

# Download the vue3 file
downloadLibrary "https://unpkg.com/vue@3.5.14/dist/vue.global.prod.js" "vue3.global.js"

# Download the js preview for excel
downloadLibrary "https://cdn.jsdelivr.net/npm/@js-preview/excel@1.4.6/lib/index.umd.js" "js-preview-excel.umd.js"

# Download the js preview for pdf
downloadLibrary "https://cdn.jsdelivr.net/npm/@js-preview/pdf@1.5.2/lib/index.umd.js" "js-preview-pdf.umd.js"

# Download the js preview for docx
downloadLibrary "https://cdn.jsdelivr.net/npm/@js-preview/docx@1.3.1/lib/index.umd.js" "js-preview-docx.umd.js"

# Download the style for docx
downloadLibrary "https://cdn.jsdelivr.net/npm/@js-preview/docx@1.3.1/lib/index.min.css" "js-preview-docx.min.css"