#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs vscode

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

install_vscode() {
    if [ -f /etc/redhat-release ]; then
    install_started
    wget https://az764295.vo.msecnd.net/stable/3b889b090b5ad5793f524b5d1d39fda662b96a2a/code-1.69.2-1658162074.el7.x86_64.rpm
    sudo dnf install code-1.69.2-1658162074.el7.x86_64.rpm -y
    sudo rm -rf code-1.69.2-1658162074.el7.x86_64.rpm
    install_completed
    elif [ -f /etc/lsb-release ]; then
    install_started
    wget https://az764295.vo.msecnd.net/stable/3b889b090b5ad5793f524b5d1d39fda662b96a2a/code_1.69.2-1658162013_amd64.deb
    sudo dpkg -i code_1.69.2-1658162013_amd64.deb
    sudo rm -rf code_1.69.2-1658162013_amd64.deb
    install_completed
    fi
}

main() {
    install_vscode
}

main
