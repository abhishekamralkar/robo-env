#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script clone the my emacs configuration on my machine.
# Fail on error

EMACS_PATH=${EMACS_PATH:-"/usr/local/bin/emacs"}
EMACS_HOME=${EMACS_HOME:-"~/.emacs.d"}
set -e

# install my emacs
install_emacs () {
    if [ ! -e "$EMACS_PATH" ];
    then
      sudo apt-get remove emacs -y \
      && sudo apt install build-essential libjansson-dev -y \
      && sudo apt install autoconf automake autotools-dev debhelper dpkg-dev imagemagick libacl1-dev libasound2-dev libdbus-1-dev libgconf2-dev libgif-dev libgnutls28-dev libgpm-dev libgtk-3-dev libjpeg-dev liblockfile-dev libm17n-dev libmagick++-dev libncurses5-dev libotf-dev libpng-dev librsvg2-dev libselinux1-dev libsystemd-dev libtiff5-dev libwebkit2gtk-4.0-dev libxaw7-dev libxml2-dev sharutils texinfo xaw3dg-dev -y \
      && mkdir -p ~/code \
      && cd ~/code \
      && rm -rf emacs \
      && time git clone https://git.savannah.gnu.org/git/emacs.git \
      && cd emacs \
      && time ./autogen.sh \
      && time ./configure --with-modules --with-json --with-xwidgets --with-imagemagick --with-mailutils \
      && time make -j9 \
      && time sudo make install
    else
       echo "Emacs already Installed"
    fi

}

get_purcell_configs () {
    if [ ! -e "$EMACS_HOME" ];
    then
      git clone https://github.com/purcell/emacs.d.git ~/.emacs.d
      #emacs
    else 
      rm -rf ${EMACS_HOME}
      git clone https://github.com/purcell/emacs.d.git ~/.emacs.d
      emacs
    fi
}


main () {
    install_emacs
    get_purcell_configs
}

main