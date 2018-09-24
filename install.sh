#! /bin/bash
UNICORN_INSTALLED=$(cat Gemfile | grep "gem 'unicorn'" | wc -l)
if [ "$UNICORN_INSTALLED" -lt 1 ]; then
    echo "Adding unicorn to Gemfile"
    echo "gem 'unicorn'" >> Gemfile
fi
bundle

echo Creating config and init files
# TODO(Gabriel): Update these links to the internal links
wget -qO- https://raw.githubusercontent.com/GabrielSturtevant/ruby-install/master/unicorn.rb >> config/unicorn.rb
wget -qO- https://raw.githubusercontent.com/GabrielSturtevant/ruby-install/master/unicorn-init.sh | sudo tee /etc/init.d/unicorn_oracle_connector > /dev/null

echo Updating init file permissions
sudo chmod 755 /etc/init.d/unicorn_oracle_connector
sudo update-rc.d unicorn_oracle_connector defaults


echo Done. Goodbye
