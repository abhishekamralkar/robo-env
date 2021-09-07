#!/usr/bin/env bash

# Author: Abhishek Anand Amralkar
# This script installs Packer

set -o errexit
set -o pipefail
set -o nounset

unset CDPATH
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PKR_BIN=${PKR_BIN:-"/usr/local/bin/packer"}
URL="https://releases.hashicorp.com/packer"
PKR_VER="$(curl -sL $URL | grep -v beta | grep -Po "_(\d*\.?){3}" | sed 's/_//' | sort -V | tail -1)"
ZIP="packer_${PKR_VER}_linux_amd64.zip"
INSTALL_DIR=${1:-/usr/local/bin/}

install_packer (){
    if [ -e "${PKR_BIN}" ];
     then
        echo "Packer is already installed"   
    else
        echo "Installing Packer..."
        sudo curl -s ${URL}/${PKR_VER}/packer_${PKR_VER}_linux_amd64.zip -o ${INSTALL_DIR}/${ZIP}
        sudo unzip -o ${INSTALL_DIR}/$ZIP -d $INSTALL_DIR && sudo rm -v ${INSTALL_DIR}/$ZIP
        echo "Done!"
    fi
}

main (){
    install_packer
 }

main
    
