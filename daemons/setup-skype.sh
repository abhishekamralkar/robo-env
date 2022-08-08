#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs skype

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

install_skype() {
    if [ -f /etc/redhat-release ]; then
    install_started
    wget https://go.skype.com/skypeforlinux-64.rpm
    sudo dnf install skypeforlinux-64.rpm -y
    sudo rm -rf skypeforlinux-64.rpm
    install_completed
    elif [ -f /etc/lsb-release]; then
    install_started
    wget https://repo.skype.com/latest/skypeforlinux-64.deb
    sudo dpkg -i skypeforlinux-64.deb
    sudo rm -rf skypeforlinux-64.deb
    install_completed
    fi
}

main() {
    install_skype
}

main