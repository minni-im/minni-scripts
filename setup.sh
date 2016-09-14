#!/bin/bash

if [[ $EUID -eq 0 ]]; then
    echo "setup-scripts doesn't works properly if it used with root user." 1>&2
    exit 1
fi

source ./scripts/setup-vars.sh

source ./scripts/setup-config.sh
source ./scripts/setup-apt.sh

source ./scripts/setup-couchdb.sh &> setup.log
source ./scripts/setup-redis.sh &> setup.log

source ./scripts/setup-deps.sh &> setup.log

source ./scripts/setup-app.sh

source ./scripts/setup-nginx.sh &> setup.log
