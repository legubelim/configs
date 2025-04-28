#!/usr/bin/env sh

## Crontab entry
#sudo crontab -e
#0 4 * * * /home/tarte/scripts/owncloud-docker-server/owncloud_backup.sh >> /home/tarte/scripts/owncloud-docker-server/owncloud_backup.log 2>&1


WORK_DIR=/home/tarte/scripts/owncloud-docker-server

set -e

echo 'OwnCloud backup script'

cd $WORK_DIR
#trap 'docker compose start' ERR
trap "cd $WORK_DIR; docker compose start" EXIT

echo 'stopping owncloud'
docker compose stop
echo 'backuping files'
duplicati-cli backup /mnt/SSD2/backups/owncloud/files /mnt/SSD_externe/owncloud --no-encryption --retention-policy='1W:1D,4W:1W,12M:1M,20Y:1Y'
echo 'backuping mysql'
duplicati-cli backup /mnt/SSD2/backups/owncloud/mysql /var/lib/docker/volumes/owncloud-docker-server_mysql --no-encryption --retention-policy='1W:1D,4W:1W,12M:1M,20Y:1Y'
echo 'backuping redis'
duplicati-cli backup /mnt/SSD2/backups/owncloud/redis /var/lib/docker/volumes/owncloud-docker-server_redis --no-encryption --retention-policy='1W:1D,4W:1W,12M:1M,20Y:1Y'
echo 'backup done'
cd -
