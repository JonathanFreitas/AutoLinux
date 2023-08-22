#!/bin/bash
sudo apt-get install neofetch -y
bash -c $'echo "neofetch" >> /etc/profile.d/mymotd.sh && chmod +x /etc/profile.d/mymotd.sh'
