#!/bin/bash

# Copyright 2022 Philip Dell
# MIT-Licence

if [ "$USER" != "root" ]
then
    echo "Please run this as root or with sudo"
    exit 2
fi

# guide from https://montessorimuddle.org/2020/12/05/uxplay-sharing-ipad-screen-on-linux-ubuntu/

# Install packages
apt-get install cmake -y

apt-get install libssl-dev libavahi-compat-libdnssd-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev gstreamer1.0-libav
apt-get install gstreamer1.0-vaapi -y

# clone repo
[ ! -d ./UxPlay ] && git clone https://github.com/FDH2/UxPlay

# create build folder
cd UxPlay
[ ! -d ./build ] && mkdir -p ./build
cd build

# build UxPlay
cmake ..
if ! test -f "./MakeFile"; then
    apt-get install gstreamer1.0-plugins-bad
    cmake ..
fi
make

# append alias to bashrc if not already in file
BASHRC_FILE="/home/$(logname)/.bashrc"
LINE="alias uxplay='${PWD}/uxplay'"
grep -xqF -- "$LINE" "$BASHRC_FILE" || echo "$LINE" >> "$BASHRC_FILE"

# source the new command
source "$BASHRC_FILE"

echo "sourced new command. Run 'uxplay' in a new terminal to start UxPlay."
