#!/bin/bash
set -e
set -o pipefail

if ! uname -a | grep 'Ubuntu' &>/dev/null; then
    echo "Sorry, this installer is meant for Ubuntu."
    exit 1
elif test "$UID" != "0"; then
    echo "Please run as root."
    exit 1
fi

export DEBIAN_NONINTERACTIVE=yes

apt-get install -yq \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

apt update -yq

apt install -yq \
    docker-ce
