#!/usr/bin/env bash

# Author: Abhishek Anand Amralkar
# This script install base packages

set -o errexit
set -o pipefail
set -o nounset

unset CDPATH
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


echo "Installing the required packages"
./setup-package.sh
retval=$?
echo "Ubuntu is upto date"
if [ $retval -ne 0 ]; then
    echo "Error in Ubuntu package please check"
fi

