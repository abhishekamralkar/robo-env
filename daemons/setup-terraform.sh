#!/usr/bin/env bash
# Author: Abhishek Anand Amralkar
# This script installs Terraform

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

TF_BIN=${TF_BIN:-"/usr/bin/terraform"}

install_terraform (){
    if [ -e "${TF_BIN}" ];
     then
        tf_ver=$(terraform -v | awk -F " " 'NR==1{print $2}')
        echo "${package}: ${tf_ver} is already installed"   
    else
        install_started
        sudo yum install -y yum-utils
        sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
        sudo yum -y install terraform
        install_completed
    fi
}

main (){
    install_terraform
 }

main
    
