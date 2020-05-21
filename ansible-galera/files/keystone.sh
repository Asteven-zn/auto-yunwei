su -s /bin/sh -c "keystone-manage db_sync" keystone
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
cd /etc/keystone/
scp -r credential-keys/ fernet-keys/ node2:/etc/keystone/
scp -r credential-keys/ fernet-keys/ node3:/etc/keystone/
