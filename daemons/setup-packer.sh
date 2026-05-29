#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs Packer.

set -o errexit
set -o pipefail
set -o nounset

unset CDPATH
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "${CURDIR}/helper-func.sh"

SETUP_DIR=$(pwd)
package=$(get_script_name)
get_release
get_date

check_packer_installed() {
    if command -v packer &> /dev/null; then
        echo "Packer is already installed: $(packer version)"
        exit 0
    fi
}

install_packer() {
    if [ -f /etc/redhat-release ]; then
        install_started
        sudo yum install -y yum-utils || { echo "Failed to install yum-utils. Exiting."; exit 1; }
        sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo || { echo "Failed to add HashiCorp repo. Exiting."; exit 1; }
        sudo yum install -y packer || { echo "Failed to install Packer. Exiting."; exit 1; }
        install_completed
    elif [ -f /etc/lsb-release ] || [ -f /etc/debian_version ]; then
        install_started
        wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null || { echo "Failed to import HashiCorp GPG key. Exiting."; exit 1; }
        echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null || { echo "Failed to add HashiCorp repo. Exiting."; exit 1; }
        sudo apt-get update -y || { echo "Failed to update package lists. Exiting."; exit 1; }
        sudo apt-get install -y packer || { echo "Failed to install Packer. Exiting."; exit 1; }
        install_completed
    else
        echo "Unsupported OS. Please install Packer manually."
        exit 1
    fi
}

main() {
    check_packer_installed
    install_packer
}

main
