#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs Zsh, Oh My Zsh, and related plugins.

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

# Default path to Zsh binary (can be overridden by an environment variable)
ZSH_BIN=${ZSH_BIN:-"/usr/bin/zsh"}

# Function to install Zsh
install_zsh() {
    if ! command -v "$ZSH_BIN" &> /dev/null; then
        echo "Zsh is not installed. Installing Zsh..."
        if [ -f /etc/redhat-release ]; then
            sudo yum install -y zsh || { echo "Failed to install Zsh on Red Hat-based system. Exiting."; exit 1; }
        elif [ -f /etc/lsb-release ] || [ -f /etc/debian_version ]; then
            sudo apt-get update -y || { echo "Failed to update package lists. Exiting."; exit 1; }
            sudo apt-get install -y zsh || { echo "Failed to install Zsh on Debian-based system. Exiting."; exit 1; }
        else
            echo "Unsupported OS. Please install Zsh manually."
            exit 1
        fi
        echo "Zsh installation completed."
    else
        echo "Zsh is already installed: $("$ZSH_BIN" --version)"
    fi
}

# Function to install Oh My Posh
install_oh_my_posh() {
    echo "Installing Oh My Posh..."
    mkdir -p ~/Bin
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/Bin || { echo "Failed to install Oh My Posh. Exiting."; exit 1; }
    echo "Oh My Posh installation completed."
}

# Function to set Zsh as the default shell
set_default_shell() {
    if [ "$SHELL" != "$ZSH_BIN" ]; then
        echo "Setting Zsh as the default shell..."
        chsh -s "$ZSH_BIN" || { echo "Failed to set Zsh as the default shell. Exiting."; exit 1; }
        echo "Zsh is now the default shell. Please log out and log back in for changes to take effect."
    else
        echo "Zsh is already the default shell."
    fi
}

# Main function to orchestrate the setup
main() {
    install_zsh
    install_oh_my_posh
    set_default_shell
    echo "Zsh setup completed successfully."
}

main