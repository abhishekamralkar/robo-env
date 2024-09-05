#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs brave 

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

install_brave() {
   if [ -f /etc/redhat-release ]; then
   install_started
   sudo dnf install dnf-plugins-core
   sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
   sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
   sudo dnf install brave-browser -y
   install_completed
   elif [ -f /etc/lsb-release ]; then
   install_started
   sudo apt install curl -y
   sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
   sudo apt update

   sudo apt install brave-browser -y
   install_completed
   fi
}

main() {
   install_brave
}

main