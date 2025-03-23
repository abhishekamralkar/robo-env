#!/bin/bash

# Array of fonts to be installed
declare -a fonts=(
    Meslo
    0xProto
    FiraCode
    FiraMono
    Hack
    Inconsolata
    IosevkaTerm
)

version='2.1.0'
fonts_dir="${HOME}/.local/share/fonts"

# Create fonts directory if it doesn't exist
if [[ ! -d "$fonts_dir" ]]; then
    mkdir -p "$fonts_dir"
fi

# Download and install each font
for font in "${fonts[@]}"; do
    zip_file="${font}.zip"
    download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${zip_file}"
    font_dir="${fonts_dir}/${font}"

    # Skip if font is already installed
    if [[ -d "$font_dir" ]]; then
        echo "Font $font is already installed. Skipping..."
        continue
    fi

    echo "Downloading $download_url"
    if ! wget -q "$download_url" -O "$zip_file"; then
        echo "Failed to download $zip_file. Skipping..."
        continue
    fi

    echo "Installing $font..."
    if ! unzip -q "$zip_file" -d "$fonts_dir"; then
        echo "Failed to unzip $zip_file. Skipping..."
        rm -f "$zip_file"
        continue
    fi

    rm "$zip_file"
done

# Remove Windows-compatible font files
find "$fonts_dir" -name '*Windows Compatible*' -delete

# Refresh font cache
fc-cache -fv
