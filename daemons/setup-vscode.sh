#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs Visual Studio Code on Debian-based and Red Hat-based systems.

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

# Function to install VS Code on Red Hat-based systems
install_vscode_redhat() {
    echo "Installing Visual Studio Code on Red Hat-based system..."
    install_started
    local vscode_rpm="https://az764295.vo.msecnd.net/stable/3b889b090b5ad5793f524b5d1d39fda662b96a2a/code-1.69.2-1658162074.el7.x86_64.rpm"
    wget -q "$vscode_rpm" -O vscode.rpm || { echo "Failed to download VS Code RPM package. Exiting."; exit 1; }
    sudo dnf install -y vscode.rpm || { echo "Failed to install VS Code RPM package. Exiting."; exit 1; }
    rm -f vscode.rpm
    install_completed
}

# Function to install VS Code on Debian-based systems
install_vscode_debian() {
    echo "Installing Visual Studio Code on Debian-based system..."
    install_started
    local vscode_deb="https://vscode.download.prss.microsoft.com/dbazure/download/stable/ddc367ed5c8936efe395cffeec279b04ffd7db78/code_1.98.2-1741788907_amd64.deb"
    wget -q "$vscode_deb" -O vscode.deb || { echo "Failed to download VS Code DEB package. Exiting."; exit 1; }
    sudo dpkg -i vscode.deb || { echo "Failed to install VS Code DEB package. Exiting."; exit 1; }
    sudo apt-get -f install -y || { echo "Failed to fix dependencies. Exiting."; exit 1; }
    rm -f vscode.deb
    install_completed
}

# Function to detect the OS and install VS Code
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

# Main function to orchestrate the setup
main() {
    install_vscode
}

main