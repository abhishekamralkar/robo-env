#!/bin/sh
# Author: Abhishek Anand Amralkar
# This script installs Hashicorp Vagrant.
unset CDPATH
#CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Fail on error
set -e

# Update deps
sudo apt-get update -y 
sudo apt-get upgrade -y

VAGRANT_VERSION=${VAGRANT_VERSION:-"2.2.4"}
DIR=${DIR:-"/tmp"}
echo "Installing Vagrant..."

# check if vagrant installed or not?
dpkg -s vagrant &> /dev/null

if [ $? -eq 0 ]; then
    echo "Vagrant is installed!"
else
    echo "Vagrant is NOT installed!"
    cd $DIR && wget --no-check-certificate https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}_x86_64.deb 
    sudo dpkg -i vagrant_${VAGRANT_VERSION}_x86_64.deb
    echo "Installing required plug-ins"
    vagrant plugin install vagrant-vbguest
    vagrant plugin update vagrant-vbguest
    vagrant plugin install vagrant-triggers
    echo "Restarting vagrant services..."
    sudo service vboxdrv restart
    cd $DIR && sudo rm -rf vagrant_${VAGRANT_VERSION}_x86_64.deb 

fi

echo "---------------------------------"
echo "Please restart VirtualBox if you are using it"
echo "Set VAGRANT_HOME if you intend to change the default location for boxes"
echo "If you see vboxdrv probe errors, please sign the key as mentioned in\nhttp://askubuntu.com/questions/760671/could-not-load-vboxdrv-after-upgrade-to-ubuntu-16-04-and-i-want-to-keep-secu"
echo "---------------------------------"
echo "Done!"
