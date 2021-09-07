#!/bin/sh

# Fail on error
set -e

# Update deps
sudo apt-get update 
sudo apt-get upgrade



echo "Installing VirtualBox..."

wget --no-check-certificate https://download.virtualbox.org/virtualbox/5.2.26/virtualbox-5.2_5.2.26-128414~Debian~stretch_amd64.deb
sudo dpkg -i virtualbox-5.2_5.2.26-128414~Debian~stretch_amd64.deb 


echo "Restarting vagrant services..."
sudo service vboxdrv restart

echo "Done!"
