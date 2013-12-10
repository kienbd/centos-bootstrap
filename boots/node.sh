#! /bin/bash

# install node onto CentOS 6 system

NODE_VERSION=0.10.4

cd /tmp
wget "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.gz"
tar -zxf "node-v$NODE_VERSION.tar.gz"
cd "node-v$NODE_VERSION"
./configure
make
make install

