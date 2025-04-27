#!/usr/bin/env sh

# Crontab entry
# crontab -e
# 0 * * * * /home/glg/scripts/dropbox_rsync.sh >> /home/glg/scripts/dropbox_rsync.log 2>&1
set -e

cd /home/glg/ownCloud

INCLUDES=`find . -name '_dropbox'  | sed "s/\.\/\(.*\)\_dropbox$/'\1' /" | tr -d "\n"`
echo "rsync -avR $INCLUDES /home/glg/Dropbox"

eval "rsync -avR $INCLUDES /home/glg/Dropbox"

