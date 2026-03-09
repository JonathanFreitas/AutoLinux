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
sudo iptables -F
sudo iptables -X
sudo iptables -Z
sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -t nat -Z
sudo iptables -t mangle -F
sudo iptables -t mangle -X
sudo iptables -t mangle -Z
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT


sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
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
