#!/bin/bash
# Author: Abhishek Anand Amralkar

set -o errexit
set -o pipefail
set -o nounset

unset CDPATH
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Pick script location
SETUP_DIR=$(pwd)

install_started() {
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "+ ${os_release}: ${package} package installation started at ${now}!+"
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
}

install_completed() {
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "+ ${os_release}: ${package} package installation finished at ${now}!+"
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
}

get_release() {
    os_release=$(cat /etc/os-release | awk -F '=' '/^NAME/{print $2}' | awk '{print $1}' | tr -d '"')
}

get_date() {
    now=$(date +"%d-%m-%Y-%H-%M-%S")
}

get_script_name() {
    basename "$0" | awk -F '-' '{print $2}' | cut -f1 -d"."
}