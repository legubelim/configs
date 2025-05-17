#!/usr/bin/env sh

## Crontab entry
#sudo crontab -e
#0 4 * * * /opt/mailcow-dockerized/mailcow_backup.sh

WORK_DIR=/opt/mailcow-dockerized
SCRIPT=$(basename "$0")
OUTPUT=$WORK_DIR/logs/backup.log 

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

# running the backup
cd $WORK_DIR
echo "#### Start of backup on $TS"
MAILCOW_BACKUP_LOCATION=/mnt/SSD2/backups/mailcow /opt/mailcow-dockerized/helper-scripts/backup_and_restore.sh backup all --delete-days 30
echo "#### End of backup"
cd -

