#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs Deb or RPM Packages

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

common_packages=("vim" "emacs" "curl" "wget" "git" "tmux" "terminator" "make" "gcc" "perl" "unzip" "rlwrap" "zsh" "python3-pip" "htop" "rsync" "python3-setuptools")

install_common_package() {
    if [ -f /etc/redhat-release ]; then  
    sudo dnf install epel-release -y 1> /dev/null
    sudo sudo dnf makecache --refresh 1> /dev/null && sudo dnf upgrade -y 1> /dev/null
    install_started
    for pack in ${common_packages[@]}; do
        sudo dnf install ${pack} -y 1> /dev/null
    done
    install_completed
    elif [ -f /etc/lsb-release ]; then
    install_started
    sudo apt update && sudo apt-get upgrade -y 1> /dev/null
    for pack in ${common_packages[@]}; do
        sudo apt install ${pack} -y 1> /dev/null
    done
    install_completed
    fi
}

get_fonts() {
    if [ -d "nerd-fonts" ]; then
    cd nerd-fonts && ./install.sh
    else
    git clone git@github.com:ryanoasis/nerd-fonts.git
    cd nerd-fonts && ./install.sh
    fi

}

main() {
    get_fonts
}
main