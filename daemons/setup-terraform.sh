#!/usr/bin/env bash

# Author: Abhishek Anand Amralkar
# This script installs Terraform

set -o errexit
set -o pipefail
set -o nounset

unset CDPATH
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TF_BIN=${TF_BIN:-"/usr/local/bin/terraform"}
URL="https://releases.hashicorp.com/terraform"
#TF_VER="$(curl -sL $URL | grep -v beta | grep -Po "_(\d*\.?){3}" | sed 's/_//' | sort -V | tail -1)"
TF_VER=0.13.6
ZIP="terraform_${TF_VER}_linux_amd64.zip"
INSTALL_DIR=${1:-/usr/local/bin}

install_terraform (){
    if [ -e "${TF_BIN}" ];
     then
        echo "Terraform is already installed"   
    else
        echo "Installing Terraform..."
        sudo curl -s ${URL}/${TF_VER}/terraform_${TF_VER}_linux_amd64.zip -o ${INSTALL_DIR}/${ZIP}
        sudo unzip -o ${INSTALL_DIR}/$ZIP -d $INSTALL_DIR && sudo rm -v ${INSTALL_DIR}/$ZIP
        echo "Done!"
    fi
}

main (){
    install_terraform
 }

main
    
