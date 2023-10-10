#!/bin/bash

# Verifica se o comando lsb_release está disponível
if ! command -v lsb_release &> /dev/null; then
    echo "O comando lsb_release não está disponível. Este script requer o pacote 'lsb-release' para funcionar."
    exit 1
fi

# Obtém a descrição do sistema
distro_description=$(lsb_release -d 2>/dev/null | cut -f2-)

# Verifica se a descrição contém "Ubuntu"
if [[ "$distro_description" == *"Ubuntu"* ]]; then
    echo "O sistema está executando o Ubuntu."
    exit 0
fi

# Verifica se a descrição contém "CentOS"
if [[ "$distro_description" == *"CentOS"* ]]; then
    echo "O sistema está executando o CentOS."
    exit 0
fi

if [[ "$distro_description" == *"Debian"* ]]; then
    echo "O sistema está executando o CentOS."
    exit 0
fi

# Se não for Ubuntu nem CentOS, exibe uma mensagem de sistema não suportado
echo "Este script suporta apenas Ubuntu e CentOS. O sistema atual é: $distro_description"
exit 1
