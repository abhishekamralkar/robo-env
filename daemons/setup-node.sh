#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs Node.js LTS.

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

NODE_BIN="${NODE_BIN:-/usr/bin/node}"

check_node_installed() {
    if [[ -e "${NODE_BIN}" ]] || command -v node &> /dev/null; then
        echo "Node.js is already installed: $(node --version)"
        exit 0
    fi
}

install_node() {
    if [ -f /etc/redhat-release ]; then
        install_started
        curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo -E bash - || { echo "Failed to set up NodeSource repo. Exiting."; exit 1; }
        sudo dnf install -y nodejs || { echo "Failed to install Node.js. Exiting."; exit 1; }
        install_completed
    elif [ -f /etc/lsb-release ] || [ -f /etc/debian_version ]; then
        install_started
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - || { echo "Failed to set up NodeSource repo. Exiting."; exit 1; }
        sudo apt-get install -y nodejs || { echo "Failed to install Node.js. Exiting."; exit 1; }
        install_completed
    else
        echo "Unsupported OS. Please install Node.js manually."
        exit 1
    fi
}

main() {
    check_node_installed
    install_node
}

main
