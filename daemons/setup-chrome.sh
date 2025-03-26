#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs Google Chrome

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

# Function to install Chrome on Red Hat-based systems
install_chrome_redhat() {
    echo "Detected Red Hat-based system. Installing Google Chrome..."
    install_started
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm || { echo "Failed to download Chrome RPM. Exiting."; exit 1; }
    sudo dnf install -y google-chrome-stable_current_x86_64.rpm || { echo "Failed to install Chrome RPM. Exiting."; exit 1; }
    rm -f google-chrome-stable_current_x86_64.rpm
    install_completed
}

# Function to install Chrome on Debian-based systems
install_chrome_debian() {
    echo "Detected Debian-based system. Installing Google Chrome..."
    install_started
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.deb || { echo "Failed to download Chrome DEB. Exiting."; exit 1; }
    sudo dpkg -i google-chrome-stable_current_x86_64.deb || { echo "Failed to install Chrome DEB. Exiting."; exit 1; }
    sudo apt-get -f install -y || { echo "Failed to fix dependencies. Exiting."; exit 1; }
    rm -f google-chrome-stable_current_x86_64.deb
    install_completed
}

# Function to detect the OS and install Chrome
install_chrome() {
    if [ -f /etc/redhat-release ]; then
        install_chrome_redhat
    elif [ -f /etc/lsb-release ] || [ -f /etc/debian_version ]; then
        install_chrome_debian
    else
        echo "Unsupported OS. Please install Google Chrome manually."
        exit 1
    fi
}

# Main function to orchestrate the setup
main() {
    install_chrome
}

main