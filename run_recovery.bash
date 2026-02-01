#!/bin/bash

# Get the directory where THIS script is saved
SCRIPT_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ask the user for a location
echo "Where would you like to save the recovery lists?"
read -p "Path (Press Enter for current directory): " USER_DIR

# Default to current directory (.) if input is empty
WORK_DIR="${USER_DIR:-.}"

# Create the directory if it doesn't exist
mkdir -p "$WORK_DIR"
# Convert to absolute path so the sub-scripts don't get confused
WORK_DIR="$(cd "$WORK_DIR" && pwd)"

echo "------------------------------------------------"
echo "Working directory set to: $WORK_DIR"
echo "------------------------------------------------"

# Run the Scanner
echo "[Scanner] Generating package lists..."
bash "$SCRIPT_HOME/scanner.bash" "$WORK_DIR"

# Run Snap Restore
echo "[Snap Restore] Restoring Snaps..."
bash "$SCRIPT_HOME/reinstall-snaps.bash" "$WORK_DIR"

# Run Apt Restore
echo "[Apt Restore] Restoring Apts..."
bash "$SCRIPT_HOME/reinstall-apts.bash" "$WORK_DIR"

echo "------------------------------------------------"
echo "All steps complete."
echo "Logs saved in: $WORK_DIR"