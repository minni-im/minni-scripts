#!/bin/bash

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
  providers: [ local ]
  # to activate Github provider
  # providers: [ local, github ]
  # github:
  #  id: your id here
  #  secret: your secret here
  #  scope: user
  #  callback: /auth/github/callback

embed:
  active: true
  providers:
    - Audio
    - Video
    - CodePen
    - Instagram
    - Vimeo
    # - Medium
    - Github
    - Gist
    - Flickr
    # - Twitter
    - Youtube
    - Spotify
    - Vine
EOF

cat > /tmp/minni.service <<EOF
[Unit]
Description=minni.im daemon

[Service]
ExecStart=/usr/bin/nodejs /home/$USER/minni-app/index.js
Restart=on-failure
User=$USER
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.agent
EOF

#  exec sudo -u $USER NODE_ENV=production /usr/bin/node /home/$USER/minni-app/index.js

if [ ! -e ~/minni-app ]; then
    # We first need to clone
    git clone https://github.com/minni-im/minni-app.git minni-app
    pushd ~/minni-app
    git checkout -f stable
    npm install
    npm run dist
    mv /tmp/settings.yml .

    sudo mv /tmp/minni.service /lib/systemd/system/minni.service
    sudo systemctl start minni.service
    sudo systemctl enable minni.service
    popd
else
    pushd ~/minni-app
    git fetch
    git checkout -f stable 2> dev/null
    git reset --hard origin/stable
    npm install
    npm run dist
    sudo systemctl restart minni.service
    popd
fi

popd
