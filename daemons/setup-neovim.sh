#!/usr/bin/env bash
set -euo pipefail

if command -v nvim >/dev/null 2>&1; then
    echo "neovim is already installed: $(nvim --version | head -1)"
    exit 0
fi

if ! command -v apt >/dev/null 2>&1; then
    echo "error: apt not found; this script only supports Debian/Ubuntu-based systems" >&2
    exit 1
fi

sudo apt update
sudo apt install -y neovim

echo "installed: $(nvim --version | head -1)"
