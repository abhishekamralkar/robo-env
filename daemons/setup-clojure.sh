#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs Clojure and Leiningen.

set -o errexit
set -o pipefail
set -o nounset

unset CDPATH
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "${CURDIR}/helper-func.sh"

SETUP_DIR=$(pwd)
package=$(get_script_name)
get_release
get_date

LEIN_BIN="${LEIN_BIN:-/usr/bin/lein}"
CLJ_BIN="${CLJ_BIN:-/usr/local/bin/clojure}"

install_leiningen() {
    if [[ -e "${LEIN_BIN}" ]]; then
        echo "Leiningen is already installed."
        return
    fi

    install_started
    curl -fsSL https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -o lein || { echo "Failed to download Leiningen. Exiting."; exit 1; }
    sudo chmod 755 lein
    sudo mv lein /usr/bin/
    sudo chmod a+x /usr/bin/lein
    install_completed
}

install_clojure() {
    if [[ -e "${CLJ_BIN}" ]]; then
        echo "Clojure is already installed."
        return
    fi

    install_started
    curl -fsSL https://github.com/clojure/brew-install/releases/latest/download/linux-install.sh -o linux-install.sh || { echo "Failed to download Clojure installer. Exiting."; exit 1; }
    chmod +x linux-install.sh
    sudo ./linux-install.sh || { echo "Failed to install Clojure. Exiting."; exit 1; }
    rm -f linux-install.sh
    install_completed
}

main() {
    install_leiningen
    install_clojure
}

main
