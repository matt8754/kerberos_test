# -*- mode: ruby -*-
# vi: set ft=ruby :

$SERVER_SCRIPT = <<EOF
touch /var/log/vagrant-ipa-setup.log; \
yum install -y git | tee -a /var/log/vagrant-ipa-setup.log;\
git clone https://gist.github.com/58e2885bef9f76d4d977.git /vagrant/config/server_config/ | tee -a /var/log/vagrant-ipa-setup.log;\
source /vagrant/config/server_config/config.sh | tee -a /var/log/vagrant-ipa-setup.log;\
sh /vagrant/config/server_config/install.sh    | tee -a /var/log/vagrant-ipa-setup.log;
EOF

$CLIENT_SCRIPT = <<EOF
touch /var/log/vagrant-ipa-setup.log; \
yum install -y git | tee -a /var/log/vagrant-ipa-setup.log;\
git clone https://gist.github.com/d461058791281e45ec17.git /vagrant/config/client_config/ | tee -a /var/log/vagrant-ipa-setup.log;\
source /vagrant/config/client_config/config.sh | tee -a /var/log/vagrant-ipa-setup.log;\
sh /vagrant/config/client_config/install.sh    | tee -a /var/log/vagrant-ipa-setup.log;
EOF

Vagrant.configure("2") do |config|
  config.vm.box = "Fedora-18-VBox"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/fedora-18-x64-vbox4210.box"
  
  config.vm.define :ipaserver do |ipaserver|
    ipaserver.vm.network :forwarded_port, guest: 80, host: 8080
    ipaserver.vm.network :forwarded_port, guest: 443, host: 1443
    ipaserver.vm.network :private_network, ip: "192.168.19.15"
    ipaserver.vm.hostname = "ipaserver.example.com"
    ipaserver.vm.provision :shell, :inline => $SERVER_SCRIPT
  end

  config.vm.define :client do |client|
    client.vm.network :forwarded_port, guest: 80, host: 8888
    client.vm.network :forwarded_port, guest: 443, host: 2443
    client.vm.network :private_network, ip: "192.168.19.20"
    client.vm.hostname = "client.example.com"
    client.vm.synced_folder "MemeGen/", "/var/www/MemeGen"
    client.vm.provision :shell, :inline => $CLIENT_SCRIPT
  end
end