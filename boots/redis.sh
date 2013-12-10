#! /bin/bash

# Many thanks:
# http://www.saltwebsites.com/2012/install-redis-245-service-centos-6

echo "Before we continue, please open up another terminal so that you can make changes to the conf files as the install occurs."
read -p "Ready to proceed? (y/n) " -e RESPONSE
if [ "$RESPONSE" != "y" ]; then
    exit
fi

echo "Ensuring that the development tools are all setup here..."
yum groupinstall 'Development Tools'

REDIS_VERSION="2.6.7"
REDIS_SOURCE_DIR="/opt/redis-$REDIS_VERSION"

echo "#fetching"
cd /opt
if [ ! -s "redis-$REDIS_VERSION.tar.gz" ]; then
    wget "http://redis.googlecode.com/files/redis-$REDIS_VERSION.tar.gz"
fi
tar -xzf "redis-$REDIS_VERSION.tar.gz"
cd "redis-$REDIS_VERSION"
echo "#compiling"
make

echo "#installing"
mkdir /etc/redis /var/lib/redis
cp src/redis-server src/redis-cli /usr/local/bin
cp redis.conf /etc/redis
sed -e "s/^daemonize no$/daemonize yes/" -e "s/^dir \.\//dir \/var\/lib\/redis\//" -e "s/^loglevel debug$/loglevel notice/" -e "s/^logfile stdout$/logfile \/var\/log\/redis.log/" redis.conf > /etc/redis/redis.conf

wget "https://raw.github.com/gist/257849/9f1e627e0b7dbe68882fa2b7bdb1b2b263522004/redis-server"
sed -i "s/usr\/local\/sbin\/redis/usr\/local\/bin\/redis/" redis-server
chmod u+x redis-server
mv redis-server /etc/init.d
chmod 755 /etc/init.d/redis-server
/sbin/chkconfig --add redis-server
/sbin/chkconfig --level 345 redis-server on

echo "Optional edit:"
echo "There's some background at the link provided at the top of this bootstrap" \
     " script, but basically background saving often fails with a fork() error" \
     " under Linux even if the system has a lot of free RAM, so this keeps disk" \
     " write errors to a minimum. It's recommended but not necessary if your sys" \
     " will always have enough memory for redis."
echo
echo "Edit /etc/sysctl.conf:"
echo -e "\t- vm.overcommit_memory = 1"

RESPONSE_4=""
while [ -z "$RESPONSE_4" ]; do
    read -p "Type 'y' to indicate that you've made the edits, or anything else to forego them. " -e RESPONSE_4
done
if [ "$RESPONSE_4" == "y" ]; then
    sysctl vm.overcommit_memory=1
fi

service redis-server start

