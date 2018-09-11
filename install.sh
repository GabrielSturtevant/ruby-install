#!/bin/bash
RUBY_VERSION='2.5.1'

pushd $HOME > /dev/null
sudo apt-get update
sudo apt-get install -y git
sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev

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

# TODO(Gabriel): Remove this line
git config --global http.sslVerify false

# TODO(Kirk): Replace this with production link
git clone https://Gabriel.Sturtevant@stash.blackline.corp/scm/fcsconn/services.connectors.oracle.git

pushd $HOME/service.connectors.oracle

gem install bundler
bundle install

. $HOME/.bashrc
popd
pwd
