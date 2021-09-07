#!/usr/bin/env bash

# Author: Abhishek Anand Amralkar
# This script installs Docker and Docker Compose

set -o errexit
set -o pipefail
set -o nounset

unset CDPATH
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCKER_PATH=${DOCKER_PATH:-"/usr/bin/docker"}
DOCKER_COMPOSE_VERSION=${DOCKER_COMPOSE_VERSION:-"1.28.2"}
DOCKER_COMPOSE_PATH=${DOCKER_COMPOSE_PATH:-"/home/aaa/System/Bin/docker-compose"}
BIN_PATH=${BIN_PATH:-"/home/aaa/System/Bin/"}

if [ ! -e ${BIN_PATH} ];
then
	mkdir -p ${BIN_PATH}
else
	echo ${BIN_PATH} "exists"
fi

USER_NAME=${USER_NAME:-"aaa"}

install_docker() {
    if [ ! -e ${DOCKER_PATH} ];
    then
        echo "Installing Docker"
        wget -qO- https://get.docker.com/ | sh
        echo "Docker Installed"
        echo "Add user in "
        sudo usermod -a -G docker $USER_NAME
    else
        echo "Docker already installed"
    fi

}

install_dockercompose(){
    if [ ! -e ${DOCKER_COMPOSE_PATH} ];
    then
        echo "Downloading Docker Compose"
        sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /home/aaa/System/Bin/docker-compose
        echo "Docker Compose installed"
        echo "Change permission to execute"
        sudo chmod +x /home/aaa/System/Bin/docker-compose
    else
        echo "Docker Compose already installed"
        fi
}

main () {
    install_docker
    install_dockercompose
}

main
