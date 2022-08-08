#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs Packer

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
CLOJURE_VERSION=${CLOJURE_VERSION:-"1.11.1.1155"}
LEIN_BIN=${LEIN_BIN:-"/usr/bin/lein"}
CLJ_BIN=${CLJ_BIN:-"/usr/local/bin/clojure"}


install_leingen () {
    install_started
    if [ ! -e "$LEIN_BIN" ];
    then
      curl -O https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && sudo chmod 755 lein && sudo mv lein /usr/bin && sudo chmod a+x ~/bin/lein
    install_completed
    else
      echo "Lein is already installed"
      fi
}


install_clojure () {
    install_started
    if [ ! -e "$CLJ_BIN" ];then 
      curl -O https://download.clojure.org/install/linux-install-${CLOJURE_VERSION}.sh && chmod +x linux-install-${CLOJURE_VERSION}.sh && sudo ./linux-install-${CLOJURE_VERSION}.sh
    install_completed
    else
        echo "Clojure is already installed"
        fi
}

main () {
    install_leingen
    install_clojure
}

main
