#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs Rust and commonly used Rust-based utilities.

set -o errexit
set -o pipefail
set -o nounset

unset CDPATH
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "${CURDIR}/helper-func.sh"

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

ensure_cargo_path() {
    local shell_name config_file
    shell_name=$(basename "$SHELL")
    case "$shell_name" in
        zsh)  config_file="$HOME/.zshrc" ;;
        bash) config_file="$HOME/.bashrc" ;;
        *)    echo "Unknown shell: $shell_name. Add \$HOME/.cargo/bin to PATH manually."; return ;;
    esac

    if ! grep -q '\.cargo/bin' "${config_file}" 2>/dev/null; then
        echo "Adding Cargo's bin directory to PATH in ${config_file}..."
        echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> "${config_file}"
    else
        echo "Cargo's bin directory is already in PATH."
    fi
    export PATH="$HOME/.cargo/bin:$PATH"
}

# Main function to orchestrate the setup
main() {
    ensure_cargo_path
    install_rust
    install_rust_utilities
    echo "Rust and utilities setup completed successfully."
}

main