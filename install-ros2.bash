#!/bin/bash

TARGET_DIR="${1:-.}"
LOG_FILE="$TARGET_DIR/install_ros2.log"

echo "--- ROS 2 Humble Install Run $(date) ---" >> "$LOG_FILE"

# 1. Check if already installed to save time
if dpkg -l | grep -q "ros-humble-desktop"; then
    echo "ROS 2 Humble is already installed. Skipping."
    echo "SKIPPED: ROS 2 Humble (Already Installed)" >> "$LOG_FILE"
    exit 0
fi

echo "Starting ROS 2 Humble Installation..."

# 2. Setup Sources & Keys
# Ensure Ubuntu Universe is enabled
if ! grep -q "^deb .*universe" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo apt install -y software-properties-common
    sudo add-apt-repository universe -y
fi

sudo apt update && sudo apt install -y curl gnupg lsb-release

# Add the GPG key
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

# Add the repository to sources list
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

# 3. Install the Package
sudo apt update
if sudo apt install -y ros-humble-desktop; then
    echo "SUCCESS: ROS 2 Humble Installed" >> "$LOG_FILE"
    
    # 4. Environment Setup (Optional: verify if user wants this in .bashrc)
    if ! grep -q "source /opt/ros/humble/setup.bash" ~/.bashrc; then
        echo "Adding ROS 2 source to ~/.bashrc..."
        echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
    fi
else
    echo "FAILURE: ROS 2 Humble failed to install" >> "$LOG_FILE"
fi

echo "ROS 2 setup complete."