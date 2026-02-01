# Reads clean names from the file and installs them
while read -r package; do
    if [ -n "$package" ]; then
        echo "Installing Snap: $package..."
        sudo snap install "$package"
    fi
done < ~/Documents/snap-list.txt