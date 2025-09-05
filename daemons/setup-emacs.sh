#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script clones my Emacs configuration onto my machine.

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

# Default paths (can be overridden by environment variables)
EMACS_PATH=${EMACS_PATH:-"/usr/bin/emacs"}
EMACS_HOME=${EMACS_HOME:-"$HOME/.emacs.d"}
EMACS_REPO=${EMACS_REPO:-"git@github.com:abhishekamralkar/myemacs.git"}

# Function to check if Emacs is installed
check_emacs_installed() {
    if ! command -v "$EMACS_PATH" &> /dev/null; then
        echo "Emacs is not installed. Please install Emacs before running this script."
        exit 1
    fi
}

# Function to clone or update Emacs configuration
setup_emacs_config() {
    echo "Setting up Emacs configuration..."
    if [ -d "$EMACS_HOME" ]; then
        echo "Existing Emacs configuration found at $EMACS_HOME. Removing it..."
        rm -rf "$EMACS_HOME" || { echo "Failed to remove existing Emacs configuration. Exiting."; exit 1; }
    fi

    echo "Cloning Emacs configuration from $EMACS_REPO..."
    git clone "$EMACS_REPO" "$EMACS_HOME" || { echo "Failed to clone Emacs configuration. Exiting."; exit 1; }
    echo "Emacs configuration successfully cloned to $EMACS_HOME."
}

# Main function to orchestrate the setup
main() {
    check_emacs_installed
    setup_emacs_config
}

main