#!/bin/bash

TARGET_DIR="${1:-.}"
SNAP_LIST="$TARGET_DIR/snap-list.txt"
LOG_FILE="$TARGET_DIR/install_failures.log"

# Check if file exists
if [ ! -f "$SNAP_LIST" ]; then
    echo "Error: $SNAP_LIST not found. Run scanner first."
    exit 1
fi

echo "Starting Snap Bulk Install..."

# Read from the list
while read -r package; do
    # Skip empty lines
    [ -z "$package" ] && continue

    echo -n "Attempting to install Snap: $package... "
    
    # Try standard install, then classic if needed.
    # We capture output to /dev/null to keep screen clean, but check exit code.
    if sudo snap install "$package" > /dev/null 2>&1 || sudo snap install "$package" --classic > /dev/null 2>&1; then
        echo "SUCCESS"
    else
        echo "FAILED (Logged)"
        echo "SNAP: $package" >> "$LOG_FILE"
    fi
done < "$SNAP_LIST"

echo "Snap restore complete."