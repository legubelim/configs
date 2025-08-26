#!/usr/bin/env sh

## Crontab entry
#sudo crontab -e
#0 4 * * * /opt/owncloud-docker-server/owncloud_backup.sh >> /opt/owncloud-docker-server/owncloud_backup.log 2>&1


WORK_DIR=/opt/owncloud-docker-server
SCRIPT=$(basename "$0")
OUTPUT=$WORK_DIR/logs/backup.log # in case of early failure
BACKUP_DRIVE=/mnt/SSD2

set -e
exit_handler() {
    # in case of error send email with the content of the log file
    ERROR_CODE=$?
    cd $WORK_DIR; docker compose start # anyway restart the service
    [ $ERROR_CODE -eq 0 ] && exit 0 || ( echo "ERROR $ERROR_CODE: sending email" ; (cat $OUTPUT || echo "log file $OUTPUT not found") | mail -s "$SCRIPT returned error $ERROR_CODE" guillaume@gkcb.fr,glegrand@gmx.net )
}
trap exit_handler EXIT

# logging in a dedicated file
TS=`date "+%Y-%m-%d_%H-%M-%S"`
OUTPUT=$WORK_DIR/logs/backup_${TS}.log
exec >> $OUTPUT 2>&1

# checking if the target drive is mounted and mount it if necessary
findmnt $BACKUP_DRIVE || mount $BACKUP_DRIVE

# running the backup
cd $WORK_DIR
echo "#### Start of backup of OwnCloud on $TS"
echo '## stopping owncloud'
docker compose stop
echo '## backuping files'
duplicati-cli backup $BACKUP_DRIVE/backups/owncloud/files /mnt/SSD1/owncloud --no-encryption --retention-policy='1W:1D,4W:1W,12M:1M,20Y:1Y' || [ $? -eq 1 ] # returns 1 if no change
echo '## backuping mysql'
duplicati-cli backup $BACKUP_DRIVE/backups/owncloud/mysql /var/lib/docker/volumes/owncloud-docker-server_mysql --no-encryption --retention-policy='1W:1D,4W:1W,12M:1M,20Y:1Y' || [ $? -eq 1 ] # returns 1 if no change
echo '## backuping redis'
duplicati-cli backup $BACKUP_DRIVE/backups/owncloud/redis /var/lib/docker/volumes/owncloud-docker-server_redis --no-encryption --retention-policy='1W:1D,4W:1W,12M:1M,20Y:1Y' || [ $? -eq 1 ] # returns 1 if no change
echo "#### End of backup of OwnCloud"
cd -
