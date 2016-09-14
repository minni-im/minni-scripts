#!/bin/bash

if [ ! -e ~/.setup/deps ]; then
    # making sure we can install latest node version 6
    curl -sL https://deb.nodesource.com/setup_6.x | sudo bash &> apt.log
    apt-install-if-needed nodejs build-essential

    touch ~/.setup/deps
fi
