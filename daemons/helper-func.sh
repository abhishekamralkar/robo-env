#!/bin/bash
# Author: Abhishek Anand Amralkar

set -o errexit
set -o pipefail
set -o nounset

unset CDPATH
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Pick script location
SETUP_DIR="$(pwd)"

install_started() {
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "+ ${os_release}: ${package} package installation started at ${now}! +"
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
}

install_completed() {
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "+ ${os_release}: ${package} package installation finished at ${now}! +"
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
}

get_release() {
    # Extract OS release name
    local os_info
    os_info=$(cat /etc/os-release | awk -F '=' '/^NAME/{print $2}' | awk '{print $1}' | tr -d '"')
    os_release="${os_info:-Unknown}" # Default to "Unknown" if empty
}

get_date() {
    # Get current date and time
    now=$(date +"%d-%m-%Y-%H-%M-%S")
}

get_script_name() {
    # Extract script name
    local script_name
    script_name=$(basename "$0" | awk -F '-' '{print $2}' | cut -f1 -d".")
    echo "${script_name:-Unknown}" # Default to "Unknown" if empty
}

get_retval() {
    # Check the return value of the last command
    local retVal=$?
    if [ $retVal -ne 0 ]; then
        echo "Error: Command failed with exit code $retVal"
    fi
    exit $retVal
}