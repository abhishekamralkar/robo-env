#!/usr/bin/env bash
# Author: Abhishek Anand Amralkar
# This script installs Terraform on Debian-based and Red Hat-based systems.

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

# Default path to Terraform binary (can be overridden by an environment variable)
TF_BIN=${TF_BIN:-"/usr/bin/terraform"}

# Function to install Terraform on Red Hat-based systems
install_terraform_redhat() {
    echo "Installing Terraform on Red Hat-based system..."
    install_started
    sudo yum install -y yum-utils || { echo "Failed to install yum-utils. Exiting."; exit 1; }
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo || { echo "Failed to add HashiCorp repository. Exiting."; exit 1; }
    sudo yum install -y terraform || { echo "Failed to install Terraform. Exiting."; exit 1; }
    install_completed
}

# Function to install Terraform on Debian-based systems
install_terraform_debian() {
    echo "Installing Terraform on Debian-based system..."
    install_started
    sudo apt-get update -y || { echo "Failed to update package lists. Exiting."; exit 1; }
    sudo apt-get install -y gnupg software-properties-common curl || { echo "Failed to install prerequisites. Exiting."; exit 1; }
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg || { echo "Failed to download HashiCorp GPG key. Exiting."; exit 1; }
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null || { echo "Failed to add HashiCorp repository. Exiting."; exit 1; }
    sudo apt-get update -y || { echo "Failed to update package lists after adding repository. Exiting."; exit 1; }
    sudo apt-get install -y terraform || { echo "Failed to install Terraform. Exiting."; exit 1; }
    install_completed
}

# Function to detect the OS and install Terraform
install_terraform() {
    if [ -e "${TF_BIN}" ]; then
        tf_ver=$("${TF_BIN}" -v | awk 'NR==1{print $2}')
        echo "${package}: Terraform ${tf_ver} is already installed."
    else
        if [ -f /etc/redhat-release ]; then
            install_terraform_redhat
        elif [ -f /etc/lsb-release ] || [ -f /etc/debian_version ]; then
            install_terraform_debian
        else
            echo "Unsupported OS. Please install Terraform manually."
            exit 1
        fi
    fi
}

# Main function to orchestrate the setup
main() {
    install_terraform
}

main