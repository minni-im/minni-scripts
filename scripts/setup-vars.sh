#!/bin/sh

if [ ! -e ~/.setup/vars ]; then
    mkdir -p ~/.setup

    echo -n "Name of your installation (default: Minni): "
    read name

    echo -n "Scheme (default http): "
    read scheme

    echo -n "Hostname (default: localhost): "
    read hostname

    if [ -z "$name" ]; then
        hostname="Minni"
    fi

    if [ -z "$hostname" ]; then
        hostname="localhost"
    fi

    if [ -z "$scheme" ]; then
        scheme="http"
    fi

    echo "Installing Minni app as '$name' with user=$USER host=$hostname scheme=$scheme listening on $binding"
    sleep 2
fi
