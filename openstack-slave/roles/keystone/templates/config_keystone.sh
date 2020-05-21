su -s /bin/sh -c "keystone-manage db_sync" keystone
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

keystone-manage bootstrap --bootstrap-password admin \
--bootstrap-admin-url http://{{ api_ip }}:5000/v3/ \
--bootstrap-internal-url http://{{ api_ip }}:5000/v3/ \
--bootstrap-public-url http://{{ api_ip }}:5000/v3/ \
--bootstrap-region-id RegionOne


sed -i '/#ServerName www.example.com:80/a ServerName {{ api_ip }}' /etc/httpd/conf/httpd.conf
ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/
