#!/usr/bin/env sh

## Crontab entry
#sudo crontab -e
#0 6 * * * /opt/dokuwiki/dokuwiki_backup.sh

WORK_DIR=/opt/dokuwiki
SCRIPT=$(basename "$0")
OUTPUT=$WORK_DIR/logs/backup.log 
BACKUP_DRIVE=/mnt/SSD2

set -e
exit_handler() {
    # in case of error send email with the content of the log file
    ERROR_CODE=$?
    [ $ERROR_CODE -eq 0 ] && exit 0 || ( echo "ERROR $ERROR_CODE: sending email" ; (cat $OUTPUT || echo "log file $OUTPUT not found") | mail -s "$SCRIPT returned error $ERROR_CODE" guillaume@gkcb.fr )
}
trap exit_handler EXIT

# logging in a dedicated file
TS=`date "+%Y-%m-%d_%H-%M-%S"`
OUTPUT=${WORK_DIR}/logs/backup_${TS}.log
exec >> $OUTPUT 2>&1

# checking if the target drive is mounted and mount it if necessary
findmnt $BACKUP_DRIVE || mount $BACKUP_DRIVE

# running the backup
cd $WORK_DIR
echo "#### Start of backup at $TS"
duplicati-cli backup $BACKUP_DRIVE/backups/dokuwiki  /mnt/SSD1/dokuwiki  --no-encryption --retention-policy='1W:1D,4W:1W,12M:1M,20Y:1Y' || [ $? -eq 1 ] # returns 1 if no change
duplicati-cli backup $BACKUP_DRIVE/backups/skemawiki /mnt/SSD1/skemawiki --no-encryption --retention-policy='1W:1D,4W:1W,12M:1M,20Y:1Y' || [ $? -eq 1 ] # returns 1 if no change
echo "#### End of backup"
cd -
