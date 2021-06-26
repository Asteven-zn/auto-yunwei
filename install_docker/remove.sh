#!/bin/bash

install_dir=$(pwd)

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
    "docker-compose"
)

delete_docker_function(){
        echo -e "\n\033[34m#>>>Stop docker\033[0m"
        sudo systemctl disable docker.service && systemctl stop docker.service

        echo -e "\n\033[34m#>>>Delete docker manifest\033[0m"
        rm -rf $HOME/.docker

        echo -e "\n\033[34m#>>>Delete docker.service\033[0m"
        sudo rm -rf /etc/systemd/system/docker.service

        echo -e "\n\033[34m#>>>Delete docker workdir\033[0m"
        sudo rm -rf /etc/docker

        echo -e "\n\033[34m#>>>Delete Docker Binary file to /usr/local/bin\033[0m"
        for item in ${docker_binary[*]}
        do
                echo -e "\n\033[33m#>>>Delete Docker Binary file ${item} to /usr/local/bin\033[0m"
                sudo rm -rf /usr/local/bin/${item}
        done
}

delete_docker_function

if [[ $? -eq 0 ]];then
        echo -e "\033[32m#>>>Delete Docker success\033[0m"
else
        echo -e "\033[31m#>>>Delete Docker failed\033[0m"
fi