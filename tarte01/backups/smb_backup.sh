#!/usr/bin/env sh

## Crontab entry
#sudo crontab -e
#0 4 * * * /home/tarte/scripts/backups/smb_backup.sh >> /home/tarte/scripts/backups//smb_backup.log 2>&1


WORK_DIR=/home/tarte/scripts/backups

set -e

echo 'SMB  backup script'

cd $WORK_DIR

echo 'backuping files'
duplicati-cli backup /mnt/SSD2/backups/shared /mnt/SSD_externe/shared --no-encryption --retention-policy='20Y:1Y' --exclude='/mnt/SSD2/backups/shared/films/' --exclude='/mnt/SSD2/backups/shared/tmp/'
echo "backup done"
cd -
