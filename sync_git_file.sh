#!/bin/bash

# used to sync the git files to other folder

# Check if two arguments were provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_folder> <destination_folder>"
    exit 1
fi

# Assign the first argument to SOURCE_FOLDER and the second to DESTINATION_FOLDER
SOURCE_FOLDER=$1
DESTINATION_FOLDER=$2

# Change to the source directory
cd "$SOURCE_FOLDER" || exit

echo "Starting file synchronization process from $SOURCE_FOLDER to $DESTINATION_FOLDER..."

# Process each file reported by git status
git status --porcelain | while read -r status file; do
    # Check if the file was deleted in the repository
    if [ "$status" = " D" ] || [ "$status" = "D " ]; then
        # Delete the file in the destination folder
        if rm -f "$DESTINATION_FOLDER/$file"; then
            echo "Deleted: $file"
        else
            echo "Failed to delete: $file"
        fi
        continue
    fi

    # For added, modified, or untracked files, copy them to the destination
    if [[ "$status" =~ ^[AM\?]+ ]]; then
        # Create the directory structure in the destination
        mkdir -p "$DESTINATION_FOLDER/$(dirname "$file")"
        # Check if the source item is a directory, and if so, use the -r option
        if [ -d "$file" ]; then
            if cp -r "$file" "$DESTINATION_FOLDER/$(dirname "$file")"; then
                echo "Copied directory: $file"
            else
                echo "Failed to copy directory: $file"
            fi
        else
            # If it's not a directory, copy the file normally
            if cp "$file" "$DESTINATION_FOLDER/$file"; then
                echo "Copied: $file"
            else
                echo "Failed to copy: $file"
            fi
        fi
    fi
done

echo "File synchronization process completed."
