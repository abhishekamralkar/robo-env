#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs Python development packages and pip.

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

# Function to install Python development packages on Red Hat-based systems
install_python_packages_redhat() {
    echo "Installing Python development packages on Red Hat-based system..."
    install_started
    sudo dnf install -y python3 python3-devel python3-pip || { echo "Failed to install Python packages on Red Hat-based system. Exiting."; exit 1; }
    install_completed
}

# Function to install Python development packages on Debian-based systems
install_python_packages_debian() {
    echo "Installing Python development packages on Debian-based system..."
    install_started
    sudo apt-get update -y || { echo "Failed to update package lists. Exiting."; exit 1; }
    sudo apt-get install -y python3 python3-dev python3-pip || { echo "Failed to install Python packages on Debian-based system. Exiting."; exit 1; }
    install_completed
}

# Function to detect the OS and install Python packages
install_python_packages() {
    if [ -f /etc/redhat-release ]; then
        install_python_packages_redhat
    elif [ -f /etc/lsb-release ] || [ -f /etc/debian_version ]; then
        install_python_packages_debian
    else
        echo "Unsupported OS. Please install Python packages manually."
        exit 1
    fi
}

# Main function to orchestrate the setup
main() {
    install_python_packages
    echo "Python setup completed successfully."
}

main