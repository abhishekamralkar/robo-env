#!/bin/bash
# Author: Abhishek Anand Amralkar
# Shell (zsh) and syntax highlighting

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

ZSH_BIN=${ZSH_BIN:-"/usr/bin/zsh"}

install_plugins () {
    if [  -e "$ZSH_BIN" ];
    then
      echo "Installing oh-my-zsh ..."
      # Install ohmyzsh
      mkdir -p ~/Bin
      curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/Bin
      echo "oh-my-posh is installed ..."
    fi
}

main () {
    install_plugins
}

main
