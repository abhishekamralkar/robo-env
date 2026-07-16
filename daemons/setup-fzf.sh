#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs FZF.

set -o errexit
set -o pipefail
set -o nounset

unset CDPATH
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

install_fzf() {
    if [[ -d "${HOME}/.fzf" ]]; then
        echo "FZF is already installed."
        return
    fi

    echo "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf" || { echo "Failed to clone fzf. Exiting."; exit 1; }
    "${HOME}/.fzf/install" --all --update-rc || { echo "Failed to install fzf. Exiting."; exit 1; }
    echo "FZF installation completed."
}

main() {
    install_fzf
}

main
