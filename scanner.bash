#!/bin/bash

# Read target dir from command line, default to '.'
TARGET_DIR="${1:-.}"
APT_LIST="$TARGET_DIR/apt-list-candidates.txt"
SNAP_LIST="$TARGET_DIR/snap-list.txt"

echo "Scanning for Snap packages..."
# Scans snap dir, removes 'common', saves to variable path
ls -1 ~/snap | grep -v "common" > "$SNAP_LIST"

echo "Scanning for Apt packages (Deep Scan)..."
echo "# Deep Scan Candidate List" > "$APT_LIST"

# Append configs, local share, and desktop shortcuts to list
ls -1 ~/.config >> "$APT_LIST"
ls -1 ~/.local/share | grep -vE "^(icons|fonts|applications|desktop-directories|mime)$" >> "$APT_LIST"
ls -1 ~/.local/share/applications | sed 's/.desktop//g' >> "$APT_LIST"

# Check dotfiles, clean output
find ~ -maxdepth 1 -name ".*" -type f | awk -F/ '{print $NF}' | sed 's/^\.//' | sed 's/rc$//' >> "$APT_LIST"

# Sort and Clean (reading and writing to the same variable path)
sort -u "$APT_LIST" -o "$APT_LIST"

echo "Scan Complete. Lists saved to: $TARGET_DIR"