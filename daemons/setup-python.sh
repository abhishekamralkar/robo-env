#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs python Packages

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

install_python_packages() {
    if [ -f /etc/redhat-release ]; then 
    install_started
    sudo dnf install python3-devel -y 1> /dev/null
    install_completed
    elif [ -f /etc/lsb-release ]; then
    install_started
    sudo apt-get install python3-dev -y 1> /dev/null
    install_completed
    fi
}

main() {
    install_python_packages
}

main