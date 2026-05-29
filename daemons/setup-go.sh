#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs Go.

set -o errexit
set -o pipefail
set -o nounset

unset CDPATH
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "${CURDIR}/helper-func.sh"

SETUP_DIR=$(pwd)
package=$(get_script_name)
get_release
get_date

GO_VERSION="${GO_VERSION:-1.24.3}"
INSTALL_DIR="${INSTALL_DIR:-/usr/local}"

detect_arch() {
    local machine
    machine=$(uname -m)
    case "$machine" in
        x86_64)  GO_ARCH="amd64" ;;
        aarch64) GO_ARCH="arm64" ;;
        armv6l)  GO_ARCH="armv6l" ;;
        *)       echo "Unsupported architecture: $machine"; exit 1 ;;
    esac
}

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

install_go() {
    if command -v go &> /dev/null; then
        echo "Go is already installed: $(go version)"
        return
    fi

    local go_url="https://golang.org/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz"
    local archive="go${GO_VERSION}.linux-${GO_ARCH}.tar.gz"

    install_started
    echo "Downloading Go ${GO_VERSION} (${GO_ARCH})..."
    curl -LO "${go_url}" || { echo "Failed to download Go. Exiting."; exit 1; }

    echo "Installing Go ${GO_VERSION} to ${INSTALL_DIR}..."
    sudo rm -rf "${INSTALL_DIR}/go"
    sudo tar -C "${INSTALL_DIR}" -xzf "${archive}" || { echo "Failed to extract Go archive. Exiting."; exit 1; }
    rm -f "${archive}"
    install_completed
}

setup_environment() {
    echo "Setting up environment variables in ${CONFIG_FILE}..."
    if ! grep -q "${INSTALL_DIR}/go/bin" "${CONFIG_FILE}"; then
        echo "export PATH=\$PATH:${INSTALL_DIR}/go/bin" >> "${CONFIG_FILE}"
    fi
    if ! grep -q "\$HOME/go/bin" "${CONFIG_FILE}"; then
        echo "export GOPATH=\$HOME/go" >> "${CONFIG_FILE}"
        echo "export PATH=\$PATH:\$GOPATH/bin" >> "${CONFIG_FILE}"
    fi
}

verify_installation() {
    export PATH="$PATH:${INSTALL_DIR}/go/bin"
    if command -v go &> /dev/null; then
        echo "Go installed: $(go version)"
    else
        echo "Go installation failed. Please check your setup."
        exit 1
    fi
}

main() {
    detect_arch
    detect_shell
    install_go
    setup_environment
    verify_installation
}

main
