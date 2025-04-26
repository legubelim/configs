#!/usr/bin/env sh

## Crontab entry
#sudo crontab -e
#0 3 * * * /home/tarte/scripts/backups/dropbox_backup.sh >> /home/tarte/scripts/backups/dropbox_backup.log 2>&1


set -e

WORK_DIR=/home/tarte/scripts/backups
cd $WORK_DIR

# finding  folders with a file _dropbox in it
INCLUDES=`find /mnt/SSD_externe/owncloud/data/files -name '_dropbox'  | sed 's/\(.*\)\_dropbox$/--include=\1\* /' | tr -d "\n"` 

#duplicati-cli backup /mnt/SSD2/backups/test_dropbox /mnt/SSD_externe/owncloud/data/files $INCLUDES --no-encryption --retention-policy='20Y:1Y,12M:1M'

##### Put the right token! #####
duplicati-cli backup dropbox://owncloud?authid=*********************** /mnt/SSD_externe/owncloud/data/files $INCLUDES --no-encryption --retention-policy='20Y:1Y,12M:1M'
