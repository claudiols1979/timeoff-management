#!/bin/bash
# OS UPDATE
apt-get update
apt-get install -y build-essential openssl libssl-dev pkg-config

#NODEJS SETUP && SQLITE
apt-get install -y build-essential openssl libssl-dev pkg-config
apt-get install -y nodejs
apt-get install npm -y
npm cache clean -f
npm install -g n
apt-get install nginx git -y
apt-get install sqlite -y

#CLONE REPO - PUBLIC REPO
cd /var/www
git clone https://github.com/claudiols1979/timeoff-management.git

#SETUP NGINX && SQLITE
apt-get install -y build-essential openssl libssl-dev pkg-config
cd /etc/nginx/sites-available
cp /var/www/timeoff-management/templates/timeoff-management /etc/nginx/sites-available/timeoff-management
rm default
systemctl start sqlite

#CREATE SYMBOLIC LINK
ln -s /etc/nginx/sites-available/timeoff-management /etc/nginx/sites-enabled/timeoff-management

#REMOVE DEFAULT FROM SITES-ENABLED DIR
rm /etc/nginx/sites-enabled/default

#INSTALLING PM2 AND UPDATING PROJECT DEPENDENCIES
npm install pm2 -g
cd /var/www/
chown -R ubuntu timeoff-management
cd timeoff-management
npm install
npm audit fix --force

#Express public dir 
cd public
npm install
npm audit fix



