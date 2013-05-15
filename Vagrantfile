# -*- mode: ruby -*-
# vi: set ft=ruby :

$SERVER_SCRIPT = <<SCRIPT
touch /var/log/vagrant-ipa-setup.log; \
sudo yum install -y git | tee -a /var/log/vagrant-ipa-setup.log;\
git clone https://gist.github.com/58e2885bef9f76d4d977.git /vagrant/config/server_config/ | tee -a /var/log/vagrant-ipa-setup.log;\
sudo source /vagrant/config/server_config/config.sh | tee -a /var/log/vagrant-ipa-setup.log;\
sudo sh /vagrant/config/server_config/install.sh    | tee -a /var/log/vagrant-ipa-setup.log;\
SCRIPT

$CLIENT_SCRIPT = <<SCRIPT
touch /var/log/vagrant-ipa-setup.log; \
sudo yum install -y git | tee -a /var/log/vagrant-ipa-setup.log;
git clone https://gist.github.com/d461058791281e45ec17.git /vagrant/config/client_config/ | tee -a /var/log/vagrant-ipa-setup.log;
sudo source /vagrant/config/client_config/config.sh | tee -a /var/log/vagrant-ipa-setup.log;
sudo sh /vagrant/config/client_config/install.sh    | tee -a /var/log/vagrant-ipa-setup.log;
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "Fedora-18-VMFusion"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/fedora-18-x64-vf503.box"
  
  config.vm.define :ipaserver do |ipaserver|
    config.vm.network :forwarded_port, guest: 80, host: 8080
    config.vm.network :forwarded_port, guest: 443, host: 1443
    config.vm.network :private_network, ip: "192.168.18.15"
    config.vm.hostname = "ipaserver.example.com"
    config.vm.provision :shell, :inline => $SERVER_SCRIPT
  end

  config.vm.define :client do |client|
    config.vm.network :forwarded_port, guest: 80, host: 8888
    config.vm.network :forwarded_port, guest: 443, host: 2443
    config.vm.network :private_network, ip: "192.168.18.20"
    config.vm.hostname = "client.example.com"
    config.vm.provision :shell, :inline => $CLIENT_SCRIPT
  end
end