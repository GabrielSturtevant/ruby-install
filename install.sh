#!/bin/bash

# Script Variables


pushd $HOME > /dev/null
sudo apt-get update
sudo apt-get install -y git
sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev
sudo apt-get install -y libpq-dev
sudo apt-get install -y nodejs
sudo apt-get install -y nginx

git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
export PATH="$HOME/.rbenv/bin:$PATH"
echo 'eval "$(rbenv init -)"' >> ~/.bashrc

git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash

git clone https://github.com/ianheggie/rbenv-binstubs.git ~/.rbenv/plugins/rbenv-binstubs

# TODO(Gabriel): Remove this line
git config --global http.sslVerify false

# TODO(Kirk): Replace this with production link
git clone https://Gabriel.Sturtevant@stash.blackline.corp/scm/fcsconn/services.connectors.oracle.git

pushd $HOME/services.connectors.oracle/Backend > /dev/null
RUBY_VERSION=$(cat Gemfile | grep ruby | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
rbenv install $RUBY_VERSION
rbenv global $RUBY_VERSION

# This is really hacky, but necessary to finish the install via a single
# script with minimal user interaction
# The gem executable is installed in the previous step
# /bin/bash -i
bash
gem install bundler || exit 1; exit 1
gem install rails
bundle install
exit
popd +0 > /dev/null

# PUMA install/configuration
export NUMBER_OF_CPUS=$( grep -c processor /proc/cpuinfo )
export APP_NAME="example"
wget -qO- https://raw.githubusercontent.com/GabrielSturtevant/ruby-install/master/puma.rb >> config/puma.rb
sed -i "s/workers 2/workers $NUMBER_OF_CPUS/g" config/puma.rb
pushd ~ > /dev/null
wget https://raw.githubusercontent.com/puma/puma/master/tools/jungle/upstart/puma-manager.conf >dev null
wget https://raw.githubusercontent.com/puma/puma/master/tools/jungle/upstart/puma.conf > /dev/null
sed -ri "s/set(.)id apps/set\1id $USER/g" puma.conf
sudo mv puma* /etc/init/
popd > /dev/null
echo "/home/$USER/$APP_NAME" | sudo tee -a /etc/puma.conf
wget -qO- https://raw.githubusercontent.com/GabrielSturtevant/ruby-install/master/puma.service | sudo tee /etc/systemd/system/puma.service > /dev/null
sudo sed -ir "s/deployer/$USER/g" /etc/systemd/system/puma.service
sudo sed -ir "s/app/example/g" /etc/systemd/system/puma.service
mkdir -p shared/pids shared/sockets shared/log
sudo systemctl start puma
systemctl status puma


# NGINX Install/Configure
export APP_NAME="example"
wget -qO- https://raw.githubusercontent.com/GabrielSturtevant/ruby-install/master/nginx-config > nginx-config
sed -ir "s/deploy/$USER/g" nginx-config
sed -ir "s/appname/$APP_NAME/g" nginx-config
sudo mv nginx-config /etc/nginx/sites-available/default

