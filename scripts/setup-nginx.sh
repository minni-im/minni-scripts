#!/bin/bash

cat > /tmp/minni.conf <<EOF
upstream node_upstream {
    ip_hash;
    server 127.0.0.1:3000;
}

map \$http_upgrade \$connection_upgrade {
    default "Upgrade";
    ''      "Close";
}

server {
    listen 8080 default_server;
    server_name $hostname;
    large_client_header_buffers 4 32k;
    client_max_body_size 50M;
    charset utf-8;
    access_log /home/$USER/logs/nginx.access.log;
    error_log /home/$USER/logs/nginx.error.log;

    location /emojis {
        internal;
        alias /home/$USER/minni-app/node_modules/emojify/assets/;
    }

    location ~ ^/images/emoji/ {
        access_log off;
        expires 30d;
        rewrite ^/images/emoji/(apple|twitter|emojione)/(.*).(svg|png)$ /emojis/$1/$3/$2.$3 last;
    }

    location ~ ^/(images/|js/|css/|sounds/|robots.txt|humans.txt|favicon.ico|.well-known/) {
        root /home/$USER/minni-app/dist/public;
        access_log off;
        expires 30d;
    }

    location / {
        proxy_http_version 1.1;
        proxy_set_header   Upgrade \$http_upgrade;
        proxy_set_header   Connection \$connection_upgrade;

        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        proxy_set_header X-NginX-Proxy true;
        proxy_pass http://node_upstream;
        proxy_redirect off;
    }
}
EOF

apt-install-if-needed nginx-full
sudo mv /tmp/minni.conf /etc/nginx/sites-available/minni
sudo rm -rf /etc/nginx/sites-enabled/minni
sudo rm -rf /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/minni /etc/nginx/sites-enabled/minni
sudo service nginx restart
