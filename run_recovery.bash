#!/bin/bash

# Get the directory where this script is saved (so we can find scanner.bash etc)
SCRIPT_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Ask the user for a location
echo "Where would you like to save the recovery lists?"
read -p "Path (Press Enter for current directory): " USER_DIR

# Default to current directory (.) if input is empty
WORK_DIR="${USER_DIR:-.}"

# Create the directory if it doesn't exist
mkdir -p "$WORK_DIR"
# Convert to absolute path for safety
WORK_DIR="$(cd "$WORK_DIR" && pwd)"

echo "------------------------------------------------"
echo "Working directory set to: $WORK_DIR"
echo "------------------------------------------------"

# 2. Run the Scanner
# We pass the WORK_DIR as the first argument ($1) to the script
echo "[1/3] Running Scanner..."
bash "$SCRIPT_HOME/scanner.bash" "$WORK_DIR"

# 3. Run Snap Restore
echo "[2/3] Restoring Snaps..."
bash "$SCRIPT_HOME/reinstall-snaps.bash" "$WORK_DIR"

# 4. Run Apt Restore
echo "[3/3] Restoring Apts..."
bash "$SCRIPT_HOME/reinstall-apts.bash" "$WORK_DIR"

echo "------------------------------------------------"
echo "All steps complete."