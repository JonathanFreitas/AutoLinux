#!/bin/bash
echo "Iniciando instalacao"
#### Instalação de Requisitos
apt-get update -y 
echo 'Configurando TIMEZONE!!!!!'
timedatectl set-timezone America/Bahia
echo "1 update concluido!!"
apt-get update -y && apt-get upgrade -y && apt-get install ca-certificates curl gnupg lsb-release -y

echo "Full update concluido!!"
# Adicionar GPG Key Oficial 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-archive-keyring.gpg
echo "Adicionar GPG Key Oficial !"
# Configurar o Repositório
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
#### Instalacao do Docker

sudo apt update -y

apt-cache policy docker-ce
echo "instalando !"
sudo apt install docker-ce -y
echo "Instalacao concluida!!"

# criacao de grupo e setando permissao ubuntu
newgrp docker;
su ubuntu;
sudo usermod -aG docker ${USER} ;
sudo su root;
echo 'Instalacao concluida!'
