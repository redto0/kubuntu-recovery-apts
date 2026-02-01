#!/bin/bash

TARGET_DIR="${1:-.}"
SNAP_LIST="$TARGET_DIR/snap-list.txt"

# Check if file exists
if [ ! -f "$SNAP_LIST" ]; then
    echo "Error: $SNAP_LIST not found. Run scanner first."
    exit 1
fi

[cite_start]# [cite: 11] Read from the variable path
while read -r package; do
    if [ -n "$package" ]; then
        echo "Installing Snap: $package..."
        sudo snap install "$package" 2>/dev/null || sudo snap install "$package" --classic 2>/dev/null
    fi
done < "$SNAP_LIST"