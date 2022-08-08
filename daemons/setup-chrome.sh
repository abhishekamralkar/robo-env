#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs chrome 

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

install_chrome() {
   if [ -f /etc/redhat-release ]; then
   install_started
   wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
   sudo dnf install -y google-chrome-stable_current_x86_64.rpm
   sudo rm -rf google-chrome-stable_current_x86_64.rpm
   install_completed
   elif [ -f /etc/lsb-release ]; then
   install_started
   wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.deb
   sudo dpkg -i google-chrome-stable_current_x86_64.deb
   sudo rm -rf google-chrome-stable_current_x86_64.deb
   install_completed
   fi
}

main() {
   install_chrome
}

main