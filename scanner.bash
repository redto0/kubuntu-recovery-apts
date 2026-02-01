# Create the files
echo "Scanning for Snap packages..."
ls -1 ~/snap | grep -v "common" > ~/Documents/snap-list.txt

echo "Scanning for Apt packages (Deep Scan)..."
echo "# Deep Scan Candidate List" > ~/Documents/apt-list-candidates.txt

# 1. Check ~/.config
ls -1 ~/.config >> ~/Documents/apt-list-candidates.txt

# 2. Check ~/.local/share (filtering system folders)
ls -1 ~/.local/share | grep -vE "^(icons|fonts|applications|desktop-directories|mime)$" >> ~/Documents/apt-list-candidates.txt

# 3. Check Desktop Shortcuts (High accuracy)
ls -1 ~/.local/share/applications | sed 's/.desktop//g' >> ~/Documents/apt-list-candidates.txt

# 4. Check Dot-files (e.g. .vimrc -> vim)
find ~ -maxdepth 1 -name ".*" -type f | awk -F/ '{print $NF}' | sed 's/^\.//' | sed 's/rc$//' >> ~/Documents/apt-list-candidates.txt

# Sort, remove duplicates, and save
sort -u ~/Documents/apt-list-candidates.txt -o ~/Documents/apt-list-candidates.txt

echo "Scan Complete. Lists saved to ~/Documents/"