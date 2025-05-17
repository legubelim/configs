#!/usr/bin/env sh

## Crontab entry
#sudo crontab -e
#0 6 * * * /opt/dokuwiki/dokuwiki_backup.sh

WORK_DIR=/opt/dokuwiki
SCRIPT=$(basename "$0")
OUTPUT=/opt/dokuwiki/logs/dokuwiki_backup.log

set -e
exit_handler() {
    # in case of error send email with the content of the log file
    ERROR_CODE=$?
    [ $ERROR_CODE -eq 0 ] && exit 0 || ( echo "ERROR $ERROR_CODE: sending email" ; (cat $OUTPUT || echo "log file $OUTPUT not found") | mail -s "$SCRIPT returned error $ERROR_CODE" guillaume@gkcb.fr )
}
trap exit_handler EXIT

# logging in a dedicated file
TS=`date "+%Y-%m-%d_%H:%M:%S"`
OUTPUT=/opt/dokuwiki/logs/dokuwiki_backup_${TS}.log
exec >> $OUTPUT 2>&1

# running the backup
cd $WORK_DIR
echo "#### Start of backup of Dokuwiki on $TS"
duplicati-cli backup /mnt/SSD2/backups/dokuwiki /mnt/SSD1/dokuwiki --no-encryption --retention-policy='1W:1D,4W:1W,12M:1M,20Y:1Y' || [ $? -eq 1 ] # returns 1 if no change
echo "#### End of backup of Dockuwiki"
cd -
