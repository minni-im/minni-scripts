#!/bin/bash

if [ ! -e ~/.setup/couchdb ]; then
    apt-install-if-needed couchdb
    echo "[CouchDB] Creating default database: minni"
    curl -X PUT http://127.0.0.1:5984/minni 2> dev/null
    touch ~/.setup/couchdb
fi
