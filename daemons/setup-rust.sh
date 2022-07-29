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

install_rust() {
    install_started
    curl https://sh.rustup.rs -sSf  | sh 
    install_completed
}

main() {
    install_rust
}

main