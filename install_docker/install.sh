#!/bin/bash
#uname -s:linux
#uname -m:aarch64 or x86_64

install_dir=$(pwd)
#Docker Package
docker_paceage="docker-20.10.7.tgz"

#Judge system architecture: aarch64 or x86_64
sys_arch=$(uname -m)
echo -e "\033[32myou server system architecture is $sys_arch\n\033[0m"
export sys_arch=$sys_arch

#Install wget tools
sudo yum install wget -y

#关闭防火强墙
echo -e "\n\033[34m#>>>>>>-Stop firewalld\033[0m"
systemctl stop firewalld
systemctl disable firewalld
echo -e "\033[33mIgnore output information********************************\033[0m"

echo -e "\n\033[34m#>>>>>>-Stop Selinux\033[0m"
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

echo -e "\n\033[34m#>>>>>>-swapoff\033[0m"
swapoff -a && sysctl -w vm.swappiness=0
sed -ri 's/.*swap.*/#&/' /etc/fstab

echo -e "\n\033[34m-------------------------------Install docker-------------------------------------\033[0m"
#Docker Binary
docker_binary=(
    "containerd"
    "containerd-shim"
    "containerd-shim-runc-v2"
    "ctr"
    "docker"
    "dockerd"
    "docker-init"
    "docker-proxy"
    "runc"
)

#Prepare Docker Binary file
for binary_file in ${docker_binary[*]}
    do
        if [[ ! -f "/usr/local/bin/${binary_file}" ]]
        then
                if [[ ! -f "${install_dir}/${docker_paceage}" ]]
                then
                        #Download Docker Binary Package
                        echo -e "\n\033[34m#>>>Download docker Binary Pakeage\033[0m"
                        sudo wget -P ${install_dir} https://download.docker.com/linux/static/stable/$(uname -m)/${docker_paceage}
                fi
        fi
done

#Decompression Docker Binary Pakeage
echo -e "\n\033[34m#>>>Decompression Docker Binary Pakeage\033[0m"
sudo tar zxf ${docker_paceage} -C ${install_dir}

#Prepare Docker Binary file to /usr/local/bin\
echo -e "\n\033[34m#>>>Prepare Docker Binary file to /usr/local/bin\033[0m"
for item in ${docker_binary[*]}
do
        echo -e "\n\033[33m#>>>Prepare Docker Binary file ${item} to /usr/local/bin\033[0m"
        sudo mv ${install_dir}/docker/${item} /usr/local/bin/
done
sudo rm -rf ${install_dir}/docker

#Download Docker-Compose Binary
if [[ ! -f "/usr/local/bin/docker-compose" ]];then
        echo -e "\n\033[34m#>>>Download Docker-Compose Binary\033[0m"
        sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose

        echo -e "\n\033[34m#>>>Chmod Docker Compose Binary file\033[0m"
        sudo chmod +x /usr/local/bin/docker-compose
fi

#Configure Docker workdir
echo -e "\n\033[34m#>>>Create docker workdir\033[0m"
if [[ ! -d "/etc/docker" ]];then
        sudo mkdir -p /etc/docker 
fi

#Configure Docker config file
echo -e "\n\033[34m#>>>Config docker daemon.json\033[0m"
cat <<EOF>/etc/docker/daemon.json
{
    "data-root": "/var/lib/docker",
    "exec-opts": ["native.cgroupdriver=systemd"],
    "insecure-registries": ["127.0.0.1/8"],
    "max-concurrent-downloads": 10,
    "log-driver": "json-file",
    "log-level": "warn",
    "log-opts": {
      "max-size": "15m",
      "max-file": "3"
      },
    "storage-driver": "overlay2",
    "experimental": true
}
EOF

echo -e "\n\033[34m#>>>Config docker.service\033[0m"
cat <<EOF>/etc/systemd/system/docker.service
[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.io

[Service]
Environment="PATH=/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin"
ExecStart=/usr/local/bin/dockerd 
ExecStartPost=/sbin/iptables -I FORWARD -s 0.0.0.0/0 -j ACCEPT
ExecReload=/bin/kill -s HUP $MAINPID
Restart=always
RestartSec=5
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
Delegate=yes
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

echo -e "\n\033[34m#>>>Enabled docker manifest\033[0m"
if [[ ! -f "$HOME/.docker/config.json" ]];then
        mkdir $HOME/.docker
        cat <<EOF>$HOME/.docker/config.json
{
        "experimental": "enabled"
}
EOF
fi

echo -e "\n\033[34m#>>>Start docker\033[0m"
systemctl daemon-reload && systemctl enable docker.service && systemctl restart docker.service

echo -e "\n\033[34m#>>>Docker running status\033[0m"
dockerstat=`systemctl status docker | grep Active | awk -F " +" '{print $3}'`
if [[ $dockerstat = "active" ]];then
        echo -e "\033[32mDocker install success\033[0m"
        docker version
else
        echo -e "\033[31mDocker install failed\033[0m"
fi

echo -e "\n\033[34m#>>>Docker compose status\033[0m"
docker-compose --version
if [[ $? -eq 0 ]];then
        echo -e "\033[32mDocker compose install success\033[0m"
else
        echo -e "\033[31mDocker compose install failed\033[0m"
fi