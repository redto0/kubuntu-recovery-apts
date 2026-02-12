#!/bin/bash

# Define where your backup files are (where the log was generated)
BACKUP_SOURCE="./" 
# The standard Linux config directory
TARGET_DIR="$HOME/.config"

echo "--- Starting Config Restoration ---"

# Loop through files in the backup directory
for file in "$BACKUP_SOURCE"*; do
    filename=$(basename "$file")
    
    # Skip the scripts themselves and the log files
    [[ "$filename" =~ \.bash$ ]] && continue
    [[ "$filename" =~ \.log$ ]] && continue
    [[ "$filename" =~ \.snap$ ]] && continue
    [[ "$filename" =~ \.assert$ ]] && continue

    echo "Restoring: $filename"
    
    # If it's a directory (like pulse, dconf, gtk-3.0), copy the whole thing
    if [ -d "$file" ]; then
        cp -r "$file" "$TARGET_DIR/"
    else
        # Otherwise, copy as a file
        cp "$file" "$TARGET_DIR/"
    fi
done

echo "Done! You may need to log out and back in for changes to take effect."