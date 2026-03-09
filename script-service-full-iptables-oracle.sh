echo 'So Roda com SUDO'
sudo su - root
echo 'verificando se estou como SUDO'
if [ "$(whoami)" != "root" ]; then
    echo "Você não está executando como root (sudo). Execute com sudo."
    exit 1
fi

echo 'Iniciando....'
sleep 2

cat <<'EOF' >  /usr/local/bin/reset-firewall.sh
#!/bin/bash
# Resetando todas as regras iptables
iptables -F
iptables -X
iptables -Z
iptables -t nat -F
iptables -t nat -X
iptables -t nat -Z
iptables -t mangle -F
iptables -t mangle -X
iptables -t mangle -Z
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
EOF

echo 'Torne executável'
chmod +x /usr/local/bin/reset-firewall.sh

echo 'Criando um service systemd'
cat <<'EOF' > /etc/systemd/system/reset-firewall.service
[Unit]
Description=Reset iptables rules at boot
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/reset-firewall.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

echo 'Ativando o service'
systemctl daemon-reload
systemctl enable reset-firewall.service
systemctl restart reset-firewall.service
echo 'finalizado!'
