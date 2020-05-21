docker run -d --net host --name galera2 \
-e WSREP_NODE_ADDRESS={{ slave1 }} \
-e WSREP_CLUSTER_ADDRESS=gcomm://{{ master }}:4567,{{ slave1 }}:4567,{{ slave2 }}:4567 \
-p 3306:3306 \
-p 4567:4567/udp \
-p 4567-4568:4567-4568 \
-p 4444:4444 \
-v /opt/mariadb/config/mysql:/etc/mysql \
-v /opt/mariadb/config/data:/var/lib/mysql:Z \
--restart=always \
panubo/mariadb-galera mysqld
