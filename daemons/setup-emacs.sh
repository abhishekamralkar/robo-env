#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script clone the my emacs configuration on my machine.

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

EMACS_PATH=${EMACS_PATH:-"/usr/local/bin/emacs"}
EMACS_HOME=${EMACS_HOME:-"~/.emacs.d"}

get_purcell_configs () {
    if [ ! -e "$EMACS_HOME" ];
    then
      install_started
      git clone https://github.com/purcell/emacs.d.git ~/.emacs.d
      install_completed
    else 
      install_started
      rm -rf ${EMACS_HOME}
      git clone https://github.com/purcell/emacs.d.git ~/.emacs.d
      install_completed
    fi
}


main () {
    get_purcell_configs
}

main