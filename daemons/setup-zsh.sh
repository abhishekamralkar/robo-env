#!/bin/sh
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
      git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
      git clone https://github.com/zsh-users/zsh-completions ~/.zsh/zsh-completions
      git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
      git clone --depth 1 https://github.com/junegunn/fzf.git ~/.zsh/.fzf
      ~/.zsh/.fzf/install
    elif [ -d ~/.zsh/zsh-syntax-highlighting ] 
      echo "oh-my-zsh is installed ..."
    fi
}

main () {
    install_plugins
}

main
