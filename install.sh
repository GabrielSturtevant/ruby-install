#!/bin/bash

# Script Variables
export NUMBER_OF_CPUS=$( grep -c processor /proc/cpuinfo )
export APPLICATION_NAME="foobar"
export APPLICATION_DIRECTORY="$HOME/$APPLICATION_NAME"
export RUBY_VERSION="2.5.1"

# Using pushd to navigate directories so user shell stays where they were durring execution
pushd $HOME > /dev/null

# Install necessary applications
sudo apt-get update
sudo apt-get install -y git
sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev
sudo apt-get install -y libpq-dev
sudo apt-get install -y nodejs
sudo apt-get install -y nginx

# TODO(TechOps): The following is only necessary for the ecample application
sudo apt-get install -y libsqlite3-dev

# Install necessary Ruby packages
git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
export PATH="$HOME/.rbenv/bin:$PATH"
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash
git clone https://github.com/ianheggie/rbenv-binstubs.git ~/.rbenv/plugins/rbenv-binstubs

rbenv install $RUBY_VERSION
rbenv global $RUBY_VERSION

# This is really hacky, but necessary to finish the install via a single script with minimal user interaction
# Gem can only be executed from the interactive shell, unless you want to break this up into multple scripts r
# Start an interactive shell
/bin/bash -i
gem install bundle
gem install rails

# TODO(TechOps): Delete this line when example application is no longer needed.
rails new $APPLICATION_NAME && pushd $APPLICATION_DIRECTORY
mkdir -p shared/pids shared/sockets shared/log

bundle install
# Exit the hacky interactive terminal
exit

# PUMA install/configuration
wget -qO- https://raw.githubusercontent.com/GabrielSturtevant/ruby-install/master/puma.rb > $APPLICATION_DIRECTORY/config/puma.rb
sed -i "s/workers 2/workers $NUMBER_OF_CPUS/g" $APPLICATION_DIRECTORY/config/puma.rb
pushd ~ > /dev/null
wget https://raw.githubusercontent.com/puma/puma/master/tools/jungle/upstart/puma-manager.conf >dev null
wget https://raw.githubusercontent.com/puma/puma/master/tools/jungle/upstart/puma.conf > /dev/null
sed -ri "s/set(.)id apps/set\1id $USER/g" puma.conf
sudo mv puma* /etc/init/
popd > /dev/null
echo "/home/$USER/$APPLICATION_NAME" | sudo tee -a /etc/puma.conf
wget -qO- https://raw.githubusercontent.com/GabrielSturtevant/ruby-install/master/puma.service | sudo tee /etc/systemd/system/puma.service > /dev/null
sudo sed -ir "s/deployer/$USER/g" /etc/systemd/system/puma.service
sudo sed -ir "s/app/$APPLICATION_NAME/g" /etc/systemd/system/puma.service

# NGINX Install/Configure
wget -qO- https://raw.githubusercontent.com/GabrielSturtevant/ruby-install/master/nginx-config > nginx-config
sed -ir "s/deploy/$USER/g" nginx-config
sed -ir "s/appname/$APPLICATION_NAME/g" nginx-config
sudo mv nginx-config /etc/nginx/sites-available/default
popd +0 > /dev/null
sudo reboot 0
