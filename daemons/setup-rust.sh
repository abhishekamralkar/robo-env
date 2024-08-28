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
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
    install_completed
}


main() {
    #install_rust
    # Update Cargo
    echo "Updating Cargo..."
    #cargo install-update -a

    # Install Rust utilities
    echo "Installing Rust command-line utilities..."
    cargo install eza
    cargo install zoxide
    cargo install bat
    cargo install atuin
    cargo install ripgrep
    cargo install dust
    cargo install git-delta
    echo "All selected Rust utilities have been installed."

    # Check if the binaries are in the system PATH
    echo "Checking if the binaries are in the system PATH..."
    for cmd in eza zoxide bat; do
        if ! command -v $cmd &> /dev/null; then
            echo "Warning: $cmd is not in your PATH. You may need to add Cargo's bin directory to your PATH."
            echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
            source ~/.zshrc
        fi
    done
}

main