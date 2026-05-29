#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs Visual Studio Code on Debian-based and Red Hat-based systems.

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

check_vscode_installed() {
    if command -v code &> /dev/null; then
        echo "VS Code is already installed: $(code --version | head -1)"
        exit 0
    fi
}

install_vscode_redhat() {
    echo "Installing Visual Studio Code on Red Hat-based system..."
    install_started
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc || { echo "Failed to import Microsoft GPG key. Exiting."; exit 1; }
    cat <<EOF | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
    sudo dnf install -y code || { echo "Failed to install VS Code. Exiting."; exit 1; }
    install_completed
}

install_vscode_debian() {
    echo "Installing Visual Studio Code on Debian-based system..."
    install_started
    sudo apt-get install -y wget gpg || { echo "Failed to install prerequisites. Exiting."; exit 1; }
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft-archive-keyring.gpg > /dev/null || { echo "Failed to import Microsoft GPG key. Exiting."; exit 1; }
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null || { echo "Failed to add VS Code repository. Exiting."; exit 1; }
    sudo apt-get update -y || { echo "Failed to update package lists. Exiting."; exit 1; }
    sudo apt-get install -y code || { echo "Failed to install VS Code. Exiting."; exit 1; }
    install_completed
}

install_vscode() {
    if [ -f /etc/redhat-release ]; then
        install_vscode_redhat
    elif [ -f /etc/lsb-release ] || [ -f /etc/debian_version ]; then
        install_vscode_debian
    else
        echo "Unsupported OS. Please install Visual Studio Code manually."
        exit 1
    fi
}

main() {
    check_vscode_installed
    install_vscode
}

main
