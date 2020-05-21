#/bin/bash

tar zxvf docker-app.tar.gz -C /usr/local/bin/

mkdir -p /etc/docker
mkdir -p /etc/docker/certs.d/reg.yunwei.edu

cp ca.crt /etc/docker/certs.d/reg.yunwei.edu/

echo "172.16.254.20 reg.yunwei.edu">>/etc/hosts

cat <<EOF>/etc/docker/daemon.json
{
  "registry-mirrors": ["http://cc83932c.m.daocloud.io"],
  "max-concurrent-downloads": 10,
  "log-driver": "json-file",
  "log-level": "warn",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
    }
}
EOF

cat <<EOF>/etc/systemd/system/docker.service
[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.io

[Service]
Environment="PATH=/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin"
ExecStart=/usr/local/bin/dockerd
ExecStartPost=/sbin/iptables -I FORWARD -s 0.0.0.0/0 -j ACCEPT
ExecReload=/bin/kill -s HUP $MAINPID
Restart=on-failure
RestartSec=5
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
Delegate=yes
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload && systemctl enable docker.service && systemctl start docker.service