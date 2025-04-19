### Setting of owncloud

# update the password in .env

cd owncloud-docker-server

sudo docker compose up -d

# check logs
sudo docker compose logs --follow owncloud

# stop and clean
# sudo docker stop
# sudo docker compose down --rmi all --volumes

