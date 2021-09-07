#!/bin/bash
# Author: Abhishek Anand Amralkar
# This script created SSH keys for my system in ED25519.

KEY_PATH=${KEY_PATH="/home/aaa/.ssh/ed25519"}

create_ssh_key (){
    if [ ! -e ${KEY_PATH} ];
    then
        echo "Creating SSH key"
        ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "abhishekamralkar@gmail.com"
        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/id_ed25519
    else
        echo "Key is present"
    fi
    }



-----------------------------------------------------------------------------------------------------------
#-o : Save the private-key using the new OpenSSH format rather than the PEM format. Actually, this option i#s implied when you specify the key type as ed25519.

#-a: It’s the numbers of KDF (Key Derivation Function) rounds. Higher numbers result in slower passphrase v#erification, increasing the resistance to brute-force password cracking should the private-key be stolen.
#-t: Specifies the type of key to create, in our case the Ed25519.
#-f: Specify the filename of the generated key file. If you want it to be discovered automatically by the S#SH agent, it must be stored in the default `.ssh` directory within your home directory.
#-C: An option to specify a comment. It’s purely informational and can be anything. But it’s usually filled#with <login>@<hostname> who generated the key.
#chmod 600 ~/.ssh/id_rsa
#chmod 644 ~/.ssh/id_rsa.pub
-----------------------------------------------------------------------------------------------------------

main (){
    create_ssh_key
}

main
