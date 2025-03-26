#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs Java

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

# Function to check if Java is already installed
check_java_installed() {
    if command -v java &> /dev/null; then
        echo "Java is already installed: $(java -version 2>&1 | head -n 1)"
        exit 0
    fi
}

# Function to install Java on Red Hat-based systems
install_java_redhat() {
    echo "Detected Red Hat-based system. Installing Java..."
    install_started
    sudo yum install -y java java-devel || { echo "Failed to install Java on Red Hat-based system. Exiting."; exit 1; }
    install_completed
}

# Function to install Java on Debian-based systems
install_java_debian() {
    echo "Detected Debian-based system. Installing Java..."
    install_started
    sudo apt-get update -y
    sudo apt-get install -y default-jdk || { echo "Failed to install Java on Debian-based system. Exiting."; exit 1; }
    install_completed
}

# Function to detect the OS and install Java
install_java() {
    if [ -f /etc/redhat-release ]; then
        install_java_redhat
    elif [ -f /etc/lsb-release ] || [ -f /etc/debian_version ]; then
        install_java_debian
    else
        echo "Unsupported OS. Please install Java manually."
        exit 1
    fi
}

# Main function to orchestrate the setup
main() {
    check_java_installed
    install_java
}

main