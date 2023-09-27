#!/bin/bash
echo -n "Quantos GB de RAM: "
read valor
mkdir /var/swap
fallocate -l $valor GB /var/swap/swapfile
chmod 600 /var/swap/swapfile
mkswap /var/swap/swapfile
swapon  /var/swap/swapfile
cp /etc/fstab /etc/fstab.bak
echo '/var/swap/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
