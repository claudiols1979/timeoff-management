#!/bin/bash

cd /var/www/timeoff-management/bin
pm2 start wwww
sudo service nginx stop && sudo service nginx start

