#!/bin/bash
mkdir -p /scripts
cat <<'EOF' > /scripts/remove_all_docker.sh
#!/bin/bash
###########################################
#
# Autor: Jonathan Freitas
#
# 
# Remover tudo que nao esta em uso


# remove all images
echo '####################################################'
echo 'Removing images ...'
echo '####################################################'
docker system prune -f
EOF
chmod 777 /scripts/remove_all_docker.sh

{ crontab -l; echo "0 3 * * 1 /scripts/remove_all_docker.sh >/dev/null 2>&1"; } | crontab -
