#!/usr/bin/env sh

apt-get update
apt-get upgrade -y
apt-get full-upgrade -y
apt-get autoremove -y
apt-get autoclean -y
