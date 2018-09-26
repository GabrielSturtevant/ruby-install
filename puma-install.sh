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
