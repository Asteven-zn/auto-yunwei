mysql -h {{ node1 }} -P 3306 -u root -p{{ dbpass }} -e "
grant process on *.* to 'clustercheckuser'@'localhost' identified by 'clustercheckpassword!';
grant process on *.* to 'clustercheckuser'@'%' identified by 'clustercheckpassword!';
flush privileges;"
