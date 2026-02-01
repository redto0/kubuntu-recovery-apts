#!/bin/bash

TARGET_DIR="${1:-.}"
APT_LIST="$TARGET_DIR/apt-list-candidates.txt"
LOG_FILE="$TARGET_DIR/install_failures.log"

if [ ! -f "$APT_LIST" ]; then
    echo "Error: $APT_LIST not found. Run scanner first."
    exit 1
fi

[cite_start]# [cite: 6] Create log in the target dir
echo "Apt Restore Log - $(date)" > "$LOG_FILE"

echo "Starting Apt Bulk Install..."

[cite_start]# [cite: 7] Loop through the list
while read -r package; do
    [[ "$package" =~ ^#.*$ ]] || [ -z "$package" ] && continue
    
    [cite_start]# [cite: 9] Install using the variable package name
    if sudo apt install -y "$package" > /dev/null 2>&1; then
        echo "SUCCESS: $package"
    else
        echo "Skipping: $package (Logged to failure file)"
        echo "$package" >> "$LOG_FILE"
    fi
done < "$APT_LIST"

[cite_start]# [cite: 10] Point user to the correct log location
echo "Check $LOG_FILE for details."