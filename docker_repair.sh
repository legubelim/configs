#!/usr/bin/env sh

# uninstall docker and re-install it

# to check packages to unsintall
#dpkg -l | grep -i docker

# uninstall
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-ce-rootless-extras docker-compose-plugin
sudo apt-get autoremove -y --purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-ce-rootless-extras docker-compose-plugin

# install
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-ce-rootless-extras docker-compose-plugin
