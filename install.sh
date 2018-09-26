#!/bin/bash
sudo apt-get install nginx -y
wget -qO- https://raw.githubusercontent.com/GabrielSturtevant/ruby-install/master/nginx-config > nginx-config
sed -ir "s/deploy/$USER/g" nginx-config
sed -ir "s/appname/$APP_NAME/g" nginx-config
sudo mv nginx-config /etc/nginx/sites-available/default

