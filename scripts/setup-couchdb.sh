#!/bin/sh

if [ ! -e ~/.setup/couchdb ]; then
    apt-install-if-needed couchdb
    touch ~/.setup/couchdb
fi
