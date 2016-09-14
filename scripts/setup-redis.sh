# redis.sh

if [ ! -e ~/.setup/redis ]; then
    apt-install-if-needed redis-server
    touch ~/.setup/redis
fi
