#!/bin/bash

TARGET_DIR="${1:-.}"
APT_LIST="$TARGET_DIR/apt-list-candidates.txt"
LOG_FILE="$TARGET_DIR/install_failures.log"

if [ ! -f "$APT_LIST" ]; then
    echo "Error: $APT_LIST not found. Run scanner first."
    exit 1
fi

# Create log in the target dir
echo "Apt Restore Log - $(date)" > "$LOG_FILE"

echo "Starting Apt Bulk Install..."

# Loop through the list
while read -r package; do
    # Skip comments or empty lines
    [[ "$package" =~ ^#.*$ ]] || [ -z "$package" ] && continue
    
    # Install using the variable package name
    if sudo apt install -y "$package" > /dev/null 2>&1; then
        echo "SUCCESS: $package"
    else
        echo "Skipping: $package (Logged to failure file)"
        echo "$package" >> "$LOG_FILE"
    fi
done < "$APT_LIST"

# Point user to the correct log location
echo "Check $LOG_FILE for details."