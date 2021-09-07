#!/usr/bin/env bash
# Author: Abhishek Anand Amralkar
# This script setsup Java 11 from Adopt Java.

sudo apt-get install -y wget apt-transport-https gnupg

if [ ! -e "public" ];
then
   wget https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public
else
   echo "Public Key present"
fi

gpg --no-default-keyring --keyring ./adoptopenjdk-keyring.gpg --import public
gpg --no-default-keyring --keyring ./adoptopenjdk-keyring.gpg --export --output adoptopenjdk-archive-keyring.gpg 

rm adoptopenjdk-keyring.gpg

sudo mv adoptopenjdk-archive-keyring.gpg /usr/share/keyrings 

if [ ! -e "/etc/apt/sources.list.d/adoptopenjdk.list" ];
then
   echo "deb [signed-by=/usr/share/keyrings/adoptopenjdk-archive-keyring.gpg] https://adoptopenjdk.jfrog.io/adoptopenjdk/deb bullseye main" | sudo tee /etc/apt/sources.list.d/adoptopenjdk.list\n            
else 
   echo "Source file updated"
fi
sudo apt-get update -y
sudo apt-get install adoptopenjdk-11-hotspot -y
rm -rf adoptopenjdk-keyring.gpg\~ public