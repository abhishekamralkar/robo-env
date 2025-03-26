#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs Rust and commonly used Rust-based utilities.

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

# Function to install Rust
install_rust() {
    if ! command -v rustup &> /dev/null; then
        echo "Installing Rust..."
        install_started
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || { echo "Failed to install Rust. Exiting."; exit 1; }
        source "$HOME/.cargo/env"
        install_completed
    else
        echo "Rust is already installed: $(rustup --version)"
    fi
}

# Function to install Rust utilities
install_rust_utilities() {
    echo "Installing Rust command-line utilities..."
    local utilities=("eza" "zoxide" "bat" "atuin" "ripgrep" "du-dust" "git-delta" "serie" "netscanner")
    for utility in "${utilities[@]}"; do
        if ! cargo install --list | grep -q "^$utility "; then
            echo "Installing $utility..."
            cargo install "$utility" || { echo "Failed to install $utility. Exiting."; exit 1; }
        else
            echo "$utility is already installed."
        fi
    done
    echo "All selected Rust utilities have been installed."
}

# Function to ensure Cargo's bin directory is in the PATH
ensure_cargo_path() {
    if ! echo "$PATH" | grep -q "$HOME/.cargo/bin"; then
        echo "Adding Cargo's bin directory to PATH..."
        echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
        source ~/.zshrc
    else
        echo "Cargo's bin directory is already in PATH."
    fi
}

# Main function to orchestrate the setup
main() {
    install_rust
    ensure_cargo_path
    install_rust_utilities
    echo "Rust and utilities setup completed successfully."
}

main