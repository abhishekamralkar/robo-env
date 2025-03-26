#!/usr/bin/env bash
# Author: Abhishek Anand Amralkar
# This script installs Docker and Docker Compose

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

# Function to install Docker on Red Hat-based systems
install_docker_redhat() {
    echo "Detected Red Hat-based system. Installing Docker..."
    install_started

    # Remove old Docker versions if they exist
    sudo yum remove -y docker \
        docker-client \
        docker-client-latest \
        docker-common \
        docker-latest \
        docker-latest-logrotate \
        docker-logrotate \
        docker-engine || true

    # Install required packages and add Docker repository
    sudo yum install -y yum-utils || { echo "Failed to install yum-utils. Exiting."; exit 1; }
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo || { echo "Failed to add Docker repository. Exiting."; exit 1; }

    # Install Docker
    sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin || { echo "Failed to install Docker. Exiting."; exit 1; }

    # Start Docker service
    sudo systemctl start docker || { echo "Failed to start Docker service. Exiting."; exit 1; }
    sudo systemctl enable docker || { echo "Failed to enable Docker service. Exiting."; exit 1; }

    install_completed
}

# Function to install Docker on Debian-based systems
install_docker_debian() {
    echo "Detected Debian-based system. Installing Docker..."
    install_started

    # Install required packages
    sudo apt-get update -y || { echo "Failed to update package lists. Exiting."; exit 1; }
    sudo apt-get install -y ca-certificates curl gnupg || { echo "Failed to install required packages. Exiting."; exit 1; }

    # Add Docker's official GPG key
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc || { echo "Failed to download Docker GPG key. Exiting."; exit 1; }
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add Docker repository
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null || { echo "Failed to add Docker repository. Exiting."; exit 1; }

    # Install Docker
    sudo apt-get update -y || { echo "Failed to update package lists. Exiting."; exit 1; }
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin || { echo "Failed to install Docker. Exiting."; exit 1; }

    # Start Docker service
    sudo systemctl start docker || { echo "Failed to start Docker service. Exiting."; exit 1; }
    sudo systemctl enable docker || { echo "Failed to enable Docker service. Exiting."; exit 1; }

    install_completed
}

# Function to detect the OS and install Docker
install_docker() {
    if [ -f /etc/redhat-release ]; then
        install_docker_redhat
    elif [ -f /etc/lsb-release ] || [ -f /etc/debian_version ]; then
        install_docker_debian
    else
        echo "Unsupported OS. Please install Docker manually."
        exit 1
    fi
}

# Main function to orchestrate the setup
main() {
    install_docker
}

main