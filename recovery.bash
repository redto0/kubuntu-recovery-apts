echo "# Deep Scan Candidate List" > ~/Documents/apt-list-candidates.txt

# 1. Check ~/.config (Standard apps)
ls -1 ~/.config >> ~/Documents/apt-list-candidates.txt

# 2. Check ~/.local/share (Data heavy apps often hide here)
# We filter out common system folders to reduce noise
ls -1 ~/.local/share | grep -vE "^(icons|fonts|applications|desktop-directories|mime)$" >> ~/Documents/apt-list-candidates.txt

# 3. Check Desktop Shortcuts (The most accurate source for GUI apps)
ls -1 ~/.local/share/applications | sed 's/.desktop//g' >> ~/Documents/apt-list-candidates.txt

# 4. Check Dot-files in your Home folder (For tools like vim, wget, etc)
# This looks for files starting with '.' and removes the '.' to guess the package name
find ~ -maxdepth 1 -name ".*" -type f | awk -F/ '{print $NF}' | sed 's/^\.//' | sed 's/rc$//' >> ~/Documents/apt-list-candidates.txt

# Sort and Clean
sort -u ~/Documents/apt-list-candidates.txt -o ~/Documents/apt-list-candidates.txt

echo "Deep scan complete. Check ~/Documents/apt-list-candidates.txt"