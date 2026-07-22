#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs Alacritty terminal emulator

set -o errexit
set -o pipefail
set -o nounset

unset CDPATH
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "${CURDIR}/helper-func.sh"

# Pick script location
SETUP_DIR=$(pwd)
package=$(get_script_name)
get_release
get_date

# Function to check if Alacritty is already installed
check_alacritty_installed() {
    if command -v alacritty &> /dev/null; then
        echo "Alacritty is already installed: $(alacritty --version)"
        exit 0
    fi
}

# Function to install Alacritty on Red Hat-based systems
install_alacritty_redhat() {
    echo "Detected Red Hat-based system. Installing Alacritty..."
    install_started
    sudo dnf install -y alacritty || { echo "Failed to install Alacritty. Exiting."; exit 1; }
    install_completed
}

# Function to install Alacritty on Debian-based systems
install_alacritty_debian() {
    echo "Detected Debian-based system. Installing Alacritty..."
    install_started
    sudo apt update || { echo "Failed to update package lists. Exiting."; exit 1; }
    sudo apt install -y alacritty || { echo "Failed to install Alacritty. Exiting."; exit 1; }
    install_completed
}

# Function to detect the OS and install Alacritty
install_alacritty() {
    if [ -f /etc/redhat-release ]; then
        install_alacritty_redhat
    elif [ -f /etc/lsb-release ] || [ -f /etc/debian_version ]; then
        install_alacritty_debian
    else
        echo "Unsupported OS. Please install Alacritty manually."
        exit 1
    fi
}

# Main function to orchestrate the setup
main() {
    check_alacritty_installed
    install_alacritty
}

main
