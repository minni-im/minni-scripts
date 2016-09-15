#!/bin/bash

if [ ! -e ~/.setup/couchdb ]; then
    apt-install-if-needed couchdb
    echo "[CouchDB] Creating default database: minni-app"
    curl -X PUT http://127.0.0.1:5984/minni-app 2> dev/null
    touch ~/.setup/couchdb
fi
