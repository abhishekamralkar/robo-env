#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script installs Nerd Fonts.

set -o errexit
set -o pipefail
set -o nounset

unset CDPATH
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

NERD_FONTS_VERSION="${NERD_FONTS_VERSION:-3.3.0}"
FONTS_DIR="${HOME}/.local/share/fonts"

declare -a fonts=(
    Meslo
    0xProto
    FiraCode
    FiraMono
    Hack
    Inconsolata
    IosevkaTerm
)

mkdir -p "${FONTS_DIR}"

for font in "${fonts[@]}"; do
    font_dir="${FONTS_DIR}/${font}"

    if [[ -d "${font_dir}" ]]; then
        echo "Font ${font} is already installed. Skipping..."
        continue
    fi

    zip_file="${font}.zip"
    download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${NERD_FONTS_VERSION}/${zip_file}"

    echo "Downloading ${font} from ${download_url}..."
    if ! wget -q "${download_url}" -O "${zip_file}"; then
        echo "Failed to download ${zip_file}. Skipping..."
        continue
    fi

    echo "Installing ${font}..."
    mkdir -p "${font_dir}"
    if ! unzip -q "${zip_file}" -d "${font_dir}"; then
        echo "Failed to unzip ${zip_file}. Skipping..."
        rm -f "${zip_file}"
        rmdir "${font_dir}" 2>/dev/null || true
        continue
    fi

    rm -f "${zip_file}"
done

find "${FONTS_DIR}" -name '*Windows Compatible*' -delete

fc-cache -fv
echo "Font installation completed."
