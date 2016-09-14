#!/bin/sh

pushd ~


cat > /tmp/settings.yml <<EOF
debug: false
port: 3000
host: 127.0.0.1
name: $name

session:
  key: minni-session-id
  secret: MinniIsTrullyAnAwesomeCollaborativeChatToolWithALotOfFeatures

couchdb:
  name: minni
  host: 127.0.0.1
  port: 5984

auth:
  providers: [ local, github ]
  github:
    id: $GITHUB_ID
    secret: $GITHUB_SECRET
    scope: user
    callback: /auth/github/callback

embed:
  active: true
  providers:
    - Audio
    - Video
    - CodePen
    - Instagram
    - Vimeo
    - Medium
    - Github
    - Gist
    - Flickr
    - Twitter
    - Youtube
    - Spotify
    - Vine
EOF

cat > /tmp/minni.conf <<EOF
#!upstart

description "minni.im"
author "Benoit Charbonnier"

start on runlevel [2345]
stop on runlevel [016]

respawn             # restart when job dies
respawn limit 5 60  # give up after 5 respawns in 60 seconds

script
  exec sudo -u $USER NODE_ENV=production /usr/bin/node /home/$USER/minni-app/index.js
end script
EOF

if [ ! -e ~/minni-app ]; then
    # We first need to clone
    git clone https://github.com/minni-im/minni-app.git minni-app
    pushd ~/minni-app
    git checkout -f stable
    npm install
    npm run dist
    mv /tmp/settings.yml .

    sudo mv /tmp/minni.conf /etc/init/minni.conf
    sudo start minni
    popd
else
    pushd ~/minni-app
    sudo stop minni
    git fetch
    git checkout -f stable 2> dev/null
    git reset --hard origin/stable
    npm install
    npm run dist
    sudo start minni
    popd
fi

popd
