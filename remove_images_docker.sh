#!/bin/bash
mkdir -p /scripts
cat <<'EOF' > /scripts/remove_images_docker.sh
#!/bin/bash
###########################################
#
# clean/remove all container/images
#
# The script will
#  - remove images
#


# remove all images
echo '####################################################'
echo 'Removing images ...'
echo '####################################################'
docker rmi $(docker images -q)
EOF
chmod 777 /scripts/remove_images_docker.sh

{ crontab -l; echo "10 8-18 * * * /scripts/remove_images_docker.sh >/dev/null 2>&1"; } | crontab -
{ crontab -l; echo "10 2 * * * /scripts/remove_images_docker.sh >/dev/null 2>&1"; } | crontab -
