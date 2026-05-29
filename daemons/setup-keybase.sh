#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs Keybase.

set -o errexit
set -o pipefail
set -o nounset

unset CDPATH
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

KB_BIN="${KB_BIN:-/usr/bin/keybase}"

check_keybase_installed() {
    if [[ -e "${KB_BIN}" ]] || command -v keybase &> /dev/null; then
        echo "Keybase is already installed."
        exit 0
    fi
}

install_keybase_debian() {
    echo "Installing Keybase on Debian-based system..."
    sudo apt-get update -y || { echo "Failed to update package lists. Exiting."; exit 1; }
    sudo apt-get upgrade -y || { echo "Failed to upgrade packages. Exiting."; exit 1; }
    curl -fsSLO https://prerelease.keybase.io/keybase_amd64.deb || { echo "Failed to download Keybase. Exiting."; exit 1; }
    sudo dpkg -i keybase_amd64.deb || true
    sudo apt-get install -f -y || { echo "Failed to fix Keybase dependencies. Exiting."; exit 1; }
    rm -f keybase_amd64.deb
    echo "Keybase installed successfully. Run 'run_keybase' to start."
}

install_keybase_redhat() {
    echo "Installing Keybase on Red Hat-based system..."
    sudo yum install -y https://prerelease.keybase.io/keybase_amd64.rpm || { echo "Failed to install Keybase. Exiting."; exit 1; }
    echo "Keybase installed successfully. Run 'run_keybase' to start."
}

install_keybase() {
    if [ -f /etc/redhat-release ]; then
        install_keybase_redhat
    elif [ -f /etc/lsb-release ] || [ -f /etc/debian_version ]; then
        install_keybase_debian
    else
        echo "Unsupported OS. Please install Keybase manually."
        exit 1
    fi
}

main() {
    check_keybase_installed
    install_keybase
}

main
