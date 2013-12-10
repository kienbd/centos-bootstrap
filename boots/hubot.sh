#! /bin/bash

# install dependencies
yum groupinstall 'Development Tools'
yum install openssl openssl-devel openssl-static crypto-utils expat expat-devel git-all

REDIS_PATH=`which redis-server`
if [ "$REDIS_PATH" != "/usr/local/bin/redis-server" ]; then
    cd /tmp
    wget https://raw.github.com/parkr/centos-bootstrap/master/bootstrap-redis
    bash bootstrap-redis
fi

# ensure node, npm are installed
NODE_PATH=`which node`
if [ "$NODE_PATH" != "/usr/local/bin/node" ]; then
    wget https://raw.github.com/parkr/centos-bootstrap/master/bootstrap-node
    bash bootstrap-node
fi

COFFEE_PATH=`which coffee`
if [ "$COFFEE_PATH" != "/usr/local/bin/coffee"]; then 
    npm install -g coffee-script
fi

# grab and install hubot
cd /opt
git clone git://github.com/github/hubot.git && cd hubot
npm install

# use hubot init script
if [ -s "/etc/init/hubot.conf" ]; then
    cd /etc/init
    wget https://raw.github.com/parkr/centos-bootstrap/master/support/hubot.conf
    echo "Edit /etc/init/hubot.conf with your info before booting up hubot."
fi

echo "! EXTREMELY IMPORTANT"
echo "! Be sure to add the user specified by HUBOT_USER in /etc/init/hubot.conf. In this example, we would run useradd -s /bin/false hubot."
echo "! From there, you can start Hubot by running start hubot from the command-line."

echo "Hubot successfully installed!"

