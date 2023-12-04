#!/bin/bash
echo 'So Roda com SUDO'
sudo su - root
echo 'verificando se estou como SUDO'
if [ "$(whoami)" != "root" ]; then
    echo "Você não está executando como root (sudo). Execute com sudo."
    exit 1
fi

echo 'Iniciando....'
sleep 2

echo 'Criando diretorio scripts'
mkdir /scripts

echo 'Configurando nable docker'
systemctl enable docker

echo 'Istalando Net-Tools'
apt install net-tools -y

export IPINTERNO=$(hostname -I | awk '{print $1}')
echo "O endereço IP interno é: $IPINTERNO"

docker swarm init --advertise-addr  $IPINTERNO

mkdir -p /scripts/configs/
echo 'Criando portainer-agent-stack.yml'
cat <<'EOF' > /scripts/configs/portainer-agent-stack.yml
version: '3.2'

services:
  agent:
    image: portainer/agent:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/lib/docker/volumes:/var/lib/docker/volumes
    networks:
      - agent_network
    deploy:
      mode: global
      placement:
        constraints: [node.platform.os == linux]

  portainer:
    image: portainer/portainer-ee:latest
    command: -H tcp://tasks.agent:9001 --tlsskipverify
    ports:
      - "9443:9443"
      - "9000:9000"
      - "8000:8000"
    volumes:
      - portainer_data:/data
    networks:
      - agent_network
    deploy:
      mode: replicated
      replicas: 1
      placement:
        constraints: [node.role == manager]

networks:
  agent_network:
    driver: overlay
    attachable: true

volumes:
  portainer_data:

EOF

docker stack deploy -c /scripts/configs/portainer-agent-stack.yml portainer
echo 'config task limit 1'
docker swarm update --task-history-limit=1
