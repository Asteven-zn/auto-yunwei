systemctl restart rabbitmq-server.service && rabbitmqctl stop_app && rabbitmqctl join_cluster --ram rabbit@node1 && rabbitmqctl start_app
