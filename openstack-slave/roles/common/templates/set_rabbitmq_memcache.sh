rabbitmqctl add_user openstack admin
rabbitmqctl set_permissions openstack ".*" ".*" ".*"
rabbitmqctl set_user_tags openstack administrator
sed -i 's/OPTIONS="-l 127.0.0.1,::1"/OPTIONS="-l 127.0.0.1,::1,{{ api_ip }}"/g' /etc/sysconfig/memcached
