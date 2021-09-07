#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs Node.

unset CDPATH
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
NODE_BIN=${NODE_BIN:-"/usr/bin/node"}

sudo apt-get install rlwrap -y
install_node () {
    if [ ! -e "$NODE_BIN" ];
    then
        curl -fsSL https://deb.nodesource.com/setup_15.x | sudo -E bash -                                                │
        sudo apt-get install -y nodejs 
    else
      echo "Node is already installed"
      fi
}


main () {
    install_node
}

main