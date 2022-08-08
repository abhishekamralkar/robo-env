#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs Java 

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

install_java() {
   if [ -f /etc/redhat-release ]; then
   install_started
   sudo yum install java java-devel -y
   install_completed
   elif [ -f /etc/lsb-release ]; then
   install_started
   sudo apt-get install openjdk -y
   install_completed
   fi
}

main() {
   install_java
}

main