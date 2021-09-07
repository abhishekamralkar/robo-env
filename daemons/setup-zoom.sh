#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs Zoom.

unset CDPATH
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ZOOM_BIN=${ZOOM_BIN:-"/usr/bin/zoom"}

# Fail on error
set -e

# Update deps
sudo apt-get update 
sudo apt-get upgrade

install_zoom(){
    if [ ! -e "$ZOOM_BIN" ];
then
    echo "Installing Zoom Client..."
    wget --no-check-certificate  https://zoom.us/client/latest/zoom_amd64.deb
    sudo dpkg -i zoom_amd64.deb
    echo "Done!"
    else
        sudo apt --fix-broken install
        echo "Zoom in installed"
    fi
}

main(){
    install_zoom
}

main

    
