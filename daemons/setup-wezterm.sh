#!/usr/bin/env bash
set -euo pipefail

if command -v wezterm >/dev/null 2>&1; then
    echo "wezterm is already installed: $(wezterm --version)"
    exit 0
fi

if ! command -v apt >/dev/null 2>&1; then
    echo "error: apt not found; this script only supports Debian/Ubuntu-based systems" >&2
    exit 1
fi

curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list

sudo apt update
sudo apt install -y wezterm

echo "installed: $(wezterm --version)"
