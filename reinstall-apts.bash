# Reads your edited list. 
# "continue" prevents the script from stopping if it can't find one package.
while read -r package; do
    # Skip comments or empty lines
    [[ "$package" =~ ^#.*$ ]] || [ -z "$package" ] && continue
    
    echo "Attempting to install Apt: $package..."
    sudo apt install -y "$package"
done < ~/Documents/apt-list-candidates.txt