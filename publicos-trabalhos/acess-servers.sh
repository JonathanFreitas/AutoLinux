#!/bin/bash

# Verifica se o arquivo de IPs foi fornecido como argumento
if [ $# -eq 0 ]; then
    echo "Por favor, forneça o caminho para o arquivo de IPs."
    exit 1
fi

# Loop através dos IPs no arquivo
while IFS= read -r ip; do
    echo "Acessando o servidor: $ip"

    # Comando para ser executado no servidor remoto
    command="sudo su - root"

    # Executa o comando no servidor remoto
    ssh -i {chave-pem} -o StrictHostKeyChecking=no ubuntu@$ip "$command" <<'EOF'
    # Agora você está no shell remoto com o usuário root
    # Você pode adicionar mais comandos aqui, se necessário

        hostnamectl

    # Exemplo: df -hT
    df -hT

    # Exemplo: fdisk -l
    crontab -l

    # Saia do shell root
    exit
EOF

    echo "=============================="
done < "$1"
