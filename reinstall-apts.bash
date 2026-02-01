#!/bin/bash

TARGET_DIR="${1:-.}"
APT_LIST="$TARGET_DIR/apt-list-candidates.txt"
LOG_FILE="$TARGET_DIR/install_failures.log"

if [ ! -f "$APT_LIST" ]; then
    echo "Error: $APT_LIST not found. Run scanner first."
    exit 1
fi

# Create/Append to log in the target dir
# (We append >> so we don't overwrite Snap failures if they ran first)
echo "Apt Restore Log - $(date)" >> "$LOG_FILE"

echo "Starting Apt Bulk Install..."

# Loop through the list
while read -r package; do
    # Skip comments or empty lines
    [[ "$package" =~ ^#.*$ ]] || [ -z "$package" ] && continue
    
    echo -n "Checking $package... "

    # Install using the variable package name
    if sudo apt install -y "$package" > /dev/null 2>&1; then
        echo "SUCCESS (Installed or Updated)"
    else
        echo "SKIPPED (Not found or error)"
        echo "APT: $package" >> "$LOG_FILE"
    fi
done < "$APT_LIST"

# Point user to the correct log location
echo "------------------------------------------------"
echo "Details logged to: $LOG_FILE"