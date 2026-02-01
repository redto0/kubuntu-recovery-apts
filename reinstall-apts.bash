#!/bin/bash

TARGET_DIR="${1:-.}"
APT_LIST="$TARGET_DIR/apt-list-candidates.txt"
FAIL_LOG="$TARGET_DIR/install_failures.log"
SUCCESS_LOG="$TARGET_DIR/install_success.log"

if [ ! -f "$APT_LIST" ]; then
    echo "Error: $APT_LIST not found. Run scanner first."
    exit 1
fi

# Create/Clear logs
echo "Apt Restore Log (Failures) - $(date)" >> "$FAIL_LOG"
echo "Apt Restore Log (Successes) - $(date)" >> "$SUCCESS_LOG"

echo "Starting Apt Bulk Install..."

# Loop through the list
while read -r package; do
    # Skip comments or empty lines
    [[ "$package" =~ ^#.*$ ]] || [ -z "$package" ] && continue
    
    echo -n "Checking $package... "

    # Install using the variable package name
    if sudo apt install -y "$package" > /dev/null 2>&1; then
        echo "SUCCESS"
        # Log to success file
        echo "$package" >> "$SUCCESS_LOG"
    else
        echo "SKIPPED"
        # Log to failure file
        echo "APT: $package" >> "$FAIL_LOG"
    fi
done < "$APT_LIST"

echo "------------------------------------------------"
echo "Done. Successes saved to: $SUCCESS_LOG"