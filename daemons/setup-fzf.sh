#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs FZF.

unset CDPATH
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

install_fzf () {
    if [ ! -e ~/.fzf ];
    then
	echo "Installing fzf"
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install
    else
        echo "FZF is installed"
fi
}


main (){
    install_fzf
}
main

