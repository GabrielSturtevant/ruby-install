#!/bin/bash

pushd $HOME > /dev/null
sudo apt-get update
sudo apt-get install -y git
sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev
sudo apt-get install -y libpq-dev
sudo apt-get install -y nodejs

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
RUBY_VERSION=$(cat Gemfile | grep ruby | grep -oP '\d+\.\d+\.\d')
echo "Ruby version: $RUBY_VERSION"
rbenv install $RUBY_VERSION
rbenv global $RUBY_VERSION

# This is really hacky, but necessary to finish the install via a single
# script with minimal user interaction
/bin/bash -i
gem install bundler
gem install rails
bundle install
exit
popd +0 > /dev/null
