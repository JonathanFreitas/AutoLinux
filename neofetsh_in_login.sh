#!/bin/bash
sudo apt-get install neofetch -y
sudo touch /etc/motd
sudo bash -c $'echo "neofetch" >> /etc/motd && chmod +x /etc/motd'
