#!/usr/bin/env bash
# Author: Abhishek Anand Amralkar
# This script setsup Alacritty.
CONFIG_DIR=${CONFIG_DIR:-"/home/aaa/.config/alacritty"}
RUSTC_PATH=${RUSTC_PATH:-"/home/aaa/.cargo/bin/rustc"}
ALACRITTY_PATH=${ALACRITTY_PATH:-"/usr/local/bin/alacritty"}

sudo apt-get install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev python3 -y
# install rust
get_rust () {
    if [ ! -e "$RUSTC_PATH" ]; then
    curl https://sh.rustup.rs -sSf  | sh
    rustup override set stable
    rustup update stable
    else
      echo "Rust Installed"
      fi
}

get_alacritty () {
    if [ ! -e "$ALACRITTY_PATH" ]; 
    then
       rm -rf /tmp/alacritty \

       cd /tmp/ \
       && git clone https://github.com/alacritty/alacritty.git \
       && cd /tmp/alacritty \
       && cargo build --release \
       && infocmp alacritty \
       && sudo tic -xe alacritty,alacritty-direct extra/alacritty.info \
       && sudo cp target/release/alacritty /usr/local/bin \
       && sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg \
       && sudo desktop-file-install extra/linux/Alacritty.desktop \
       && sudo update-desktop-database \
       && sudo mkdir -p /usr/local/share/man/man1 \
       && sudo gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null \
       && mkdir -p ${ZDOTDIR:-~}/.zsh_functions \
       && echo 'fpath+=${ZDOTDIR:-~}/.zsh_functions' >> ${ZDOTDIR:-~}/.zshrc \
       && cp extra/completions/_alacritty ${ZDOTDIR:-~}/.zsh_functions/_alacritty
    else
       echo "Alacritty Installed"
    fi
}

config_alacritty () {
    if [ ! -e "$CONFIG_DIR" ]; then
    mkdir -p ${CONFIG_DIR}
    cd ${CONFIG_DIR}  && wget https://raw.githubusercontent.com/abhishekamralkar/configs/master/alacritty/alacritty.yml
    fi
}

main () {
    get_rust
    get_alacritty
    config_alacritty
}

main
