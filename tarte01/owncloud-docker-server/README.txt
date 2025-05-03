### Setting of owncloud

# update the password in .env

cd owncloud-docker-server
sudo docker compose up -d
# works if volumes already exist !!

# check logs
sudo docker compose logs --follow owncloud

# stop and clean
# sudo docker compose stop
# sudo docker compose down

# to remove images and volumes: sudo docker compose down --rmi all --volumes

