#!/bin/bash
# OS UPDATE
sudo apt-get update
sudo apt-get install -y build-essential openssl libssl-dev pkg-config

#NODEJS SETUP && SQLITE
sudo apt-get install -y build-essential openssl libssl-dev pkg-config
sudo apt-get install -y nodejs
sudo apt-get install npm -y
sudo npm cache clean -f
sudo npm install -g n
sudo apt-get install nginx git -y
sudo apt-get install sqlite -y

#CLONE REPO - PUBLIC REPO
cd /var/www
sudo git clone https://github.com/claudiols1979/timeoff-management.git

#SETUP NGINX && SQLITE
sudo apt-get install -y build-essential openssl libssl-dev pkg-config
cd /etc/nginx/sites-available
sudo cp /var/www/timeoff-management/templates/timeoff-management /etc/nginx/sites-available/timeoff-management
sudo rm default
sudo systemctl start sqlite

#CREATE SYMBOLIC LINK
sudo ln -s /etc/nginx/sites-available/timeoff-management /etc/nginx/sites-enabled/timeoff-management

#REMOVE DEFAULT FROM SITES-ENABLED DIR
sudo rm /etc/nginx/sites-enabled/default

#INSTALLING PM2 AND UPDATING PROJECT DEPENDENCIES
sudo npm install pm2 -g
cd /var/www/
sudo chown -R ubuntu timeoff-management
cd timeoff-management
sudo npm install
sudo npm audit fix --force

#Express public dir 
cd public
sudo npm install
sudo npm audit fix



