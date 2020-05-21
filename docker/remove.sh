#/bin/bash

systemctl disable docker.service && systemctl stop docker.service && systemctl daemon-reload

rm -rf /usr/local/bin/docker*
rm -rf /etc/docker
rm -rf /etc/systemd/system/docker.service
