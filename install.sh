#!/bin/bash
RUBY_VERSION='2.5.1'

pushd $HOME
sudo apt-get update
sudo apt-get install -y git

git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc

git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc

git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash

git clone https://github.com/ianheggie/rbenv-binstubs.git ~/.rbenv/plugins/rbenv-binstubs

. $HOME/.bashrc # Reload bashrc content

rbenv install $RUBY_VERSION
rbenv global $RUBY_VERSION
