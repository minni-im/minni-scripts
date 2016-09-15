#!/bin/bash

pushd ~

cat > /tmp/settings.yml <<EOF
debug: false
host: 127.0.0.1
name: $name

auth:
  providers: [ local ]
  # to activate Github provider
  # providers: [ local, github ]
  # github:
  #  id: your id here
  #  secret: your secret here

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
    git clone https://github.com/minni-im/minni-app.git minni-app
    pushd ~/minni-app
    git checkout -f stable 2> /dev/null
    npm install
    npm run dist
    mv /tmp/settings.yml ./settings.yml

    # we create the systemd config file
    sudo mv /tmp/minni.service /etc/systemd/system/minni.service
    sudo systemctl daemon-reload
    # activating to start on boot
    sudo systemctl enable minni.service
    # starting right now
    sudo systemctl start minni.service
    popd
else
    pushd ~/minni-app
    git fetch
    git checkout -f stable 2> /dev/null
    git reset --hard origin/stable
    npm install
    npm run dist
    sudo systemctl restart minni.service
    popd
fi

popd
