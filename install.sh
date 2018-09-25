export NUMBER_OF_CPUS=$( grep -c processor /proc/cpuinfo )
export APP_NAME="example"
wget -qO- https://raw.githubusercontent.com/GabrielSturtevant/ruby-install/master/puma.rb >> config/puma.rb
sed -i "s/workers 2/workers $NUMBER_OF_CPUS/g" config/puma.rb
pushd ~
wget https://raw.githubusercontent.com/puma/puma/master/tools/jungle/upstart/puma-manager.conf
wget https://raw.githubusercontent.com/puma/puma/master/tools/jungle/upstart/puma.conf
sed -ri "s/set(.)id apps/set\1id $USER/g" puma.conf
sudo mv puma* /etc/init/

popd

echo "/home/$USER/$APP_NAME" | sudo tee -a /etc/puma.conf
wget -qO- https://raw.githubusercontent.com/GabrielSturtevant/ruby-install/master/puma.service | sudo tee /etc/systemd/system/puma.service
sudo sed -ire "s/(User|Group)=deployer/\1=$USER/g" -ire "s/\/deployer\/app/$USER\/$APP_NAME/g" /etc/systemd/system/puma.service
