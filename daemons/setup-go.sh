#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

# Specify the Go version (can be overridden by an environment variable)
GO_VERSION="${GO_VERSION:-1.24.1}"

# Specify the installation directory (can be overridden by an environment variable)
INSTALL_DIR="${INSTALL_DIR:-/usr/local}"

# URL to download the Go binary
GO_URL="https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz"

# Function to detect the user's shell and configuration file
detect_shell() {
    local shell_name
    shell_name=$(basename "$SHELL")
    if [[ "$shell_name" == "zsh" ]]; then
        CONFIG_FILE="$HOME/.zshrc"
    elif [[ "$shell_name" == "bash" ]]; then
        CONFIG_FILE="$HOME/.bashrc"
    else
        echo "Unsupported shell: $shell_name. Please update your PATH manually."
        exit 1
    fi
}

# Function to download and install Go
install_go() {
    echo "Downloading Go ${GO_VERSION}..."
    curl -LO "${GO_URL}" || { echo "Failed to download Go. Exiting."; exit 1; }

    echo "Installing Go ${GO_VERSION} to ${INSTALL_DIR}..."
    sudo tar -C "${INSTALL_DIR}" -xzf "go${GO_VERSION}.linux-amd64.tar.gz" || { echo "Failed to extract Go archive. Exiting."; exit 1; }

    # Cleanup the downloaded archive
    rm -f "go${GO_VERSION}.linux-amd64.tar.gz"
}

# Function to set up environment variables
setup_environment() {
    echo "Setting up environment variables in ${CONFIG_FILE}..."
    if ! grep -q "${INSTALL_DIR}/go/bin" "${CONFIG_FILE}"; then
        echo "export PATH=\$PATH:${INSTALL_DIR}/go/bin" >> "${CONFIG_FILE}"
    fi
    if ! grep -q "\$HOME/go/bin" "${CONFIG_FILE}"; then
        echo "export GOPATH=\$HOME/go" >> "${CONFIG_FILE}"
        echo "export PATH=\$PATH:\$GOPATH/bin" >> "${CONFIG_FILE}"
    fi

    # Apply changes to the current shell session
    echo "Applying changes to the current shell session..."
    source "${CONFIG_FILE}"
}

# Function to verify the installation
verify_installation() {
    if command -v go &> /dev/null; then
        echo "Go version: $(go version)"
        echo "Go ${GO_VERSION} has been installed successfully!"
    else
        echo "Go installation failed. Please check your setup."
        exit 1
    fi
}

# Main function to orchestrate the setup
main() {
    detect_shell
    install_go
    setup_environment
    verify_installation
}

# Execute the main function
main