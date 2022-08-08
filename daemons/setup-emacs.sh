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

get_emacs() {
    if [ -d "$EMACS_HOME" ]; then
      rm -rf $EMACS_HOME
      #install_started
      #git clone git@github.com:abhishekamralkar/emacs.d.git ~/.emacs.d
      #install_completed
    else 
      #install_started
      #git clone git@github.com:abhishekamralkar/emacs.d.git ~/.emacs.d
      #install_completed
      echo "hello"
    fi
}

misc() {
  mkdir -p ~/.emacs.d/themes 
  cd ~/.emacs.d/themes/ && wget https://raw.githubusercontent.com/greduan/emacs-theme-gruvbox/master/gruvbox-theme.el
  cd ~/.emacs.d/lisp/ && wget https://raw.githubusercontent.com/abhishekamralkar/configs/master/emacs/init-local.el
  cd ~/.emacs.d/lisp/ && wget https://raw.githubusercontent.com/abhishekamralkar/configs/master/emacs/init-go.el
  git clone git@github.com:jwiegley/use-package.git ~/.emacs.d/site-lisp/use-package
}

main () {
    get_emacs
    misc
}

main