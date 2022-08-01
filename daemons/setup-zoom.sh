#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs Zoom.

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

ZOOM_BIN=${ZOOM_BIN:-"/usr/bin/zoom"}

install_zoom(){
    if [ ! -e "$ZOOM_BIN" ] && [ -f /etc/redhat-release ]; then 
    install_started
    wget --no-check-certificate https://zoom.us/client/latest/zoom_x86_64.rpm
    sudo dnf install zoom_x86_64.rpm -y
    sudo rm -rf zoom_x86_64.rpm
    install_completed
    elif [ ! -e "$ZOOM_BIN" ] && [ -f /etc/lsb-release ]; then
    install_started
    wget --no-check-certificate  https://zoom.us/client/latest/zoom_amd64.deb
    sudo dpkg -i zoom_amd64.deb
    sudo rm -rf zoom_amd64.deb
    install_completed
    fi
}

main(){
    install_zoom
}

main

    
