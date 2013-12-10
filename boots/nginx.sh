#! /bin/bash

gem install passenger
passenger-install-nginx-module --auto

# accept HTTP/HTTPS connections
iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT
iptables -I INPUT 1 -p tcp --dport 443 -j ACCEPT
/etc/init.d/iptables save

# get that init script
if [ ! -f "/etc/init.d/nginx" ]; then
    wget https://raw.github.com/parkr/centos-bootstrap/master/support/nginx-service-script.sh
    sudo mv nginx-service-script.sh /etc/init.d/nginx
    sudo chmod +x /etc/init.d/nginx
    sudo /sbin/chkconfig nginx on
fi
