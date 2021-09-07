#!/usr/bin/env bash

# Author: Abhishek Anand Amralkar
# This script installs Debian Packages

set -o errexit
set -o pipefail
set -o nounset

unset CDPATH
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Pick script location
SETUP_DIR=$(pwd)

# Update repo and libraries
echo "Updating packages..."
sudo apt-get update
echo "Upgrading system..."
sudo apt-get upgrade

# Base Packages
echo "Setting up utilities..."
sudo apt-get install linux-image-$(uname -r|sed 's,[^-]*-[^-]*-,,') linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') -y
sudo apt-get install sudo vim emacs fonts-inconsolata curl wget git awscli tmux \
                     fonts-indic make gcc perl unzip terminator rlwrap mutt zsh openvpn python3-pip htop rsync python-dev \
                     python-setuptools ruby-full fonts-firacode -y
echo "Utilities installation finished"

# A Ruby script that colorizes the ls output with color and icons
sudo gem install colorls
