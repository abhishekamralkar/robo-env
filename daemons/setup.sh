#!/usr/bin/env bash

# Author: Abhishek Anand Amralkar
# This script install all packages

set -o errexit
set -o pipefail
set -o nounset

unset CDPATH
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

./setup-package.sh
./setup-python.sh
