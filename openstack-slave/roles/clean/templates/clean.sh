#/bin/bash

#remove database
for db in {keystone,glance,nova,nova_api,nova_cell0,neutron,cinder,placement};
do
  mysql -u root -p123 -e "drop database $db";
done;

#stop mariadb-server
systemctl stop mariadb