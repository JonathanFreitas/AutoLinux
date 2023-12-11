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

sudo cat <<'EOF' > /etc/profile.adm
#
# EMAIL DE AVISO DE ACESSO
#
rootalert() {
echo 'ALERTA - Acesso SHELL'
echo
echo 'Servidor: 'hostname
echo 'IP do servidor: ' wget http://ipecho.net/plain -O - -q
echo 'Data: 'date
echo 'Usuario: 'last -1 | grep logged | awk '{ print $1 }'
echo 'TTY: 'last -1 | grep logged | awk '{ print $2 }'
echo 'Origem: 'last -1 | grep logged | awk '{ print $3 }'
echo
echo 'Estes usuários estão ativos neste instante:'
echo who | awk '{print $1}'
echo
echo 'Últimos 10 acessos efetuados:'
echo last -n 10
echo
echo 'Informações: Horário deste acesso, Uptime e Load Averange atual'
echo uptime
echo
}
rootalert | mail -s "Alerta: Acesso via SSH [hostname]" monitoramento.aws@emepar.com.br jonathan@grupo2ag.com.br thiago@delend.finance
EOF

sudo chmod 777 /etc/profile.adm

echo -e "#Comando de monitoramento de ACESSO SSH\n \n/etc/profile.adm &" >> ~/.bash_profile

echo 'Finalizado!!'
