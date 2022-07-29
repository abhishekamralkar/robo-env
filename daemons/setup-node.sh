#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs Node.

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
NODE_BIN=${NODE_BIN:-"/usr/bin/node"}

install_node () {
    if [ ! -e "$NODE_BIN" ];
    then
        install_started
        curl -fsSL https://deb.nodesource.com/setup_15.x | sudo -E bash -                                                │
        sudo apt-get install -y nodejs 
        install_completed
    else
      echo "Node is already installed"
      fi
}


main () {
    install_node
}

main