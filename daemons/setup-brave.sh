#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs Brave browser

set -o errexit
set -o pipefail
set -o nounset

unset CDPATH
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ./helper-func.sh

# Pick script location
SETUP_DIR=$(pwd)
package=$(get_script_name)
get_release
get_date

# Function to check if Brave is already installed
check_brave_installed() {
    if command -v brave-browser &> /dev/null; then
        echo "Brave browser is already installed: $(brave-browser --version)"
        exit 0
    fi
}

# Function to install Brave on Red Hat-based systems
install_brave_redhat() {
    echo "Detected Red Hat-based system. Installing Brave browser..."
    install_started
    sudo dnf install -y dnf-plugins-core || { echo "Failed to install dnf-plugins-core. Exiting."; exit 1; }
    sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo || { echo "Failed to add Brave repository. Exiting."; exit 1; }
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc || { echo "Failed to import Brave GPG key. Exiting."; exit 1; }
    sudo dnf install -y brave-browser || { echo "Failed to install Brave browser. Exiting."; exit 1; }
    install_completed
}

# Function to install Brave on Debian-based systems
install_brave_debian() {
    echo "Detected Debian-based system. Installing Brave browser..."
    install_started
    sudo apt install -y curl || { echo "Failed to install curl. Exiting."; exit 1; }
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg || { echo "Failed to download Brave GPG key. Exiting."; exit 1; }
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list || { echo "Failed to add Brave repository. Exiting."; exit 1; }
    sudo apt update || { echo "Failed to update package lists. Exiting."; exit 1; }
    sudo apt install -y brave-browser || { echo "Failed to install Brave browser. Exiting."; exit 1; }
    install_completed
}

# Function to detect the OS and install Brave
install_brave() {
    if [ -f /etc/redhat-release ]; then
        install_brave_redhat
    elif [ -f /etc/lsb-release ] || [ -f /etc/debian_version ]; then
        install_brave_debian
    else
        echo "Unsupported OS. Please install Brave browser manually."
        exit 1
    fi
}

# Main function to orchestrate the setup
main() {
    check_brave_installed
    install_brave
}

main