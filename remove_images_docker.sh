#!/bin/bash
mkdir /scripts
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

(crontab -l; echo "0 22 * * * /scripts/remove_images_docker.sh >/dev/null 2>&1") | sort -u | crontab -
