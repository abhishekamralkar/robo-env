#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs common packages and fonts on Debian-based and Red Hat-based systems.

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

# List of common packages to install
common_packages=("vim" "emacs" "curl" "wget" "git" "tmux" "terminator" "make" "gcc" "perl" "unzip" "rlwrap" "zsh" "python3-pip" "htop" "rsync" "python3-setuptools" "stow" "bat" "zoxide" "fzf" "ripgrep" "tldr" "fonts-firacode")

# Function to install common packages on Red Hat-based systems
install_common_packages_redhat() {
    echo "Installing common packages on Red Hat-based system..."
    sudo dnf install -y epel-release || { echo "Failed to install EPEL repository. Exiting."; exit 1; }
    sudo dnf makecache --refresh || { echo "Failed to refresh package cache. Exiting."; exit 1; }
    sudo dnf upgrade -y || { echo "Failed to upgrade packages. Exiting."; exit 1; }
    install_started
    for package in "${common_packages[@]}"; do
        sudo dnf install -y "$package" || { echo "Failed to install $package. Exiting."; exit 1; }
    done
    install_completed
}

# Function to install common packages on Debian-based systems
install_common_packages_debian() {
    echo "Installing common packages on Debian-based system..."
    sudo apt-get update -y || { echo "Failed to update package lists. Exiting."; exit 1; }
    sudo apt-get upgrade -y || { echo "Failed to upgrade packages. Exiting."; exit 1; }
    install_started
    for package in "${common_packages[@]}"; do
        sudo apt-get install -y "$package" || { echo "Failed to install $package. Exiting."; exit 1; }
    done
    install_completed
}

# Function to detect the OS and install common packages
install_common_packages() {
    if [ -f /etc/redhat-release ]; then
        install_common_packages_redhat
    elif [ -f /etc/lsb-release ] || [ -f /etc/debian_version ]; then
        install_common_packages_debian
    else
        echo "Unsupported OS. Please install packages manually."
        exit 1
    fi
}

# Main function to orchestrate the setup
main() {
    install_common_packages
    echo "Linux setup completed successfully."
}

main