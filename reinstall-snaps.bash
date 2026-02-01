#!/bin/bash

TARGET_DIR="${1:-.}"
SNAP_LIST="$TARGET_DIR/snap-list.txt"
FAIL_LOG="$TARGET_DIR/install_failures.log"
SUCCESS_LOG="$TARGET_DIR/install_success.log"

if [ ! -f "$SNAP_LIST" ]; then
    echo "Error: $SNAP_LIST not found. Run scanner first."
    exit 1
fi

echo "Starting Snap Bulk Install..."

while read -r package; do
    [ -z "$package" ] && continue

    echo -n "Attempting to install Snap: $package... "
    
    if sudo snap install "$package" > /dev/null 2>&1 || sudo snap install "$package" --classic > /dev/null 2>&1; then
        echo "SUCCESS"
        echo "SNAP: $package" >> "$SUCCESS_LOG"
    else
        echo "FAILED"
        echo "SNAP: $package" >> "$FAIL_LOG"
    fi
done < "$SNAP_LIST"

echo "Snap restore complete."