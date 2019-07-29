#!/bin/bash
 
if [ -d /var/www/timeoff-management ] 
then
    cd /var/www/timeoff-management/bin/
    pm2 stop 0
    sudo rm -rf /var/www/timeoff-management
fi

