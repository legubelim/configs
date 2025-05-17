#!/usr/bin/env sh

## Crontab entry
#sudo crontab -e
#0 6 * * * /opt/dropbox/dropbox_backup.sh

WORK_DIR=/opt/dropbox
SCRIPT=$(basename "$0")
OUTPUT=$WORK_DIR/logs/backup.log 

set -e
exit_handler() {
    # in case of error send email with the content of the log file
    ERROR_CODE=$?
    [ $ERROR_CODE -eq 0 ] && exit 0 || ( echo "ERROR $ERROR_CODE: sending email" ; (cat $OUTPUT || echo "log file $OUTPUT not found") | mail -s "$SCRIPT returned error $ERROR_CODE" guillaume@gkcb.fr,glegrand@gmx.net )
}
trap exit_handler EXIT

# logging in a dedicated file
TS=`date "+%Y-%m-%d_%H-%M-%S"`
OUTPUT=${WORK_DIR}/logs/backup_${TS}.log
exec >> $OUTPUT 2>&1

# running the backup
cd $WORK_DIR
echo "#### Start of backup at $TS"
# finding  folders with a file _dropbox in it
INCLUDES=`find /mnt/SSD1/owncloud/data/files -name '_dropbox'  | sed "s/\(.*\)\_dropbox$/--include='\1\*' /" | tr -d "\n"` 
##### Put the right token! #####
echo "duplicati-cli backup dropbox://owncloud?authid=****************************************************** /mnt/SSD1/owncloud/data/files $INCLUDES --no-encryption --retention-policy='20Y:1Y,12M:1M'"
eval "duplicati-cli backup dropbox://owncloud?authid=1627ef528d582d8e89cb42f595af54dd:Bs7.7qW_e_sBb0XyL9H2W /mnt/SSD1/owncloud/data/files $INCLUDES --no-encryption --retention-policy='20Y:1Y,12M:1M'" || [ $? -eq 1 ] # returns 1 if no change
echo "#### End of backup"
cd -

