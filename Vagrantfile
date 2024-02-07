# -*- mode: ruby -*-
# vi: set ft=ruby :

var_box = "generic/rocky9"

Vagrant.configure("2") do |config|
  
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  config.vm.define "console" do |nodes|
    nodes.vm.box = var_box
    nodes.vm.hostname= "console"
    nodes.vm.network "private_network", ip: "192.168.56.10"
    nodes.vm.provision :hosts, :sync_hosts => true
    nodes.vm.provider "virtualbox" do |v|
      v.memory = "512"
      v.cpus = "1"
      v.name = "console"
      v.customize ["modifyvm", :id, "--groups", "/Patroni"]
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
    
    nodes.vm.synced_folder ".", "/vagrant"
    nodes.vm.synced_folder "./keys", "/vagrant_keys"
    nodes.vm.provision "shell", inline: "cp /vagrant/.vagrant/machines/console/virtualbox/private_key /vagrant_keys/key"
    nodes.vm.provision "shell", inline: <<-SHELL
      sudo sed -i 's/PermitRootLogin no/PermitRootLogin yes/' /etc/ssh/sshd_config
      echo -e "root\nroot" | passwd root
      sudo systemctl restart sshd
      sudo sh /vagrant_keys/config.sh
      sudo sh /vagrant_keys/generate_public_key.sh
      sudo sh /vagrant_keys/copy_keys.sh
      systemctl stop firewalld
    SHELL
  end

  # Postgres Nodes
  (1..3).each do |i|
    config.vm.define "pg#{i}" do |nodes|
      nodes.vm.box = var_box
      nodes.vm.hostname = "pg#{i}"
      nodes.vm.network "private_network", ip: "192.168.56.1#{i}"
      nodes.vm.provision :hosts, :sync_hosts => true
      nodes.vm.provider "virtualbox" do |v|
        v.memory = "1024"
        v.cpus = "2"
        v.name = "pg#{i}"
        v.customize ["modifyvm", :id, "--groups", "/Patroni"]
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      end
      
      nodes.vm.synced_folder ".", "/vagrant"
      nodes.vm.synced_folder "./keys", "/vagrant_keys"
      nodes.vm.provision "shell", inline: <<-SHELL
        sudo sed -i 's/PermitRootLogin no/PermitRootLogin yes/' /etc/ssh/sshd_config
        echo -e "root\nroot" | passwd root
        sudo systemctl restart sshd
        sudo sh /vagrant_keys/config.sh
        sudo sh /vagrant_keys/generate_public_key.sh
        sudo sh /vagrant_keys/copy_keys.sh
        systemctl stop firewalld
      SHELL
    end
   end

  # Etcd
  (1..3).each do |i|
    config.vm.define "etcd#{i}" do |nodes|
      nodes.vm.box = var_box
      nodes.vm.hostname = "etcd#{i}"
      nodes.vm.network "private_network", ip: "192.168.56.2#{i}"
      nodes.vm.provision :hosts, :sync_hosts => true
      nodes.vm.provider "virtualbox" do |v|
        v.memory = "512"
        v.cpus = "1"
        v.name = "etcd#{i}"
        v.customize ["modifyvm", :id, "--groups", "/Patroni"]
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      end
      
      nodes.vm.synced_folder ".", "/vagrant"
      nodes.vm.synced_folder "./keys", "/vagrant_keys"
      nodes.vm.provision "shell", inline: <<-SHELL
        sudo sed -i 's/PermitRootLogin no/PermitRootLogin yes/' /etc/ssh/sshd_config
        echo -e "root\nroot" | passwd root
        sudo systemctl restart sshd
        sudo sh /vagrant_keys/config.sh
        sudo sh /vagrant_keys/generate_public_key.sh
        sudo sh /vagrant_keys/copy_keys.sh
        systemctl stop firewalld
      SHELL
    end
  end

   # Etcd
  (1..2).each do |i|
    config.vm.define "ha#{i}" do |nodes|
      nodes.vm.box = var_box
      nodes.vm.hostname = "ha#{i}"
      nodes.vm.network "private_network", ip: "192.168.56.3#{i}"
      nodes.vm.provision :hosts, :sync_hosts => true
      nodes.vm.provider "virtualbox" do |v|
        v.memory = "512"
        v.cpus = "1"
        v.name = "ha#{i}"
        v.customize ["modifyvm", :id, "--groups", "/Patroni"]
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      end

      nodes.vm.synced_folder ".", "/vagrant"
      nodes.vm.synced_folder "./keys", "/vagrant_keys"
      nodes.vm.provision "shell", inline: <<-SHELL
        sudo sed -i 's/PermitRootLogin no/PermitRootLogin yes/' /etc/ssh/sshd_config
        echo -e "root\nroot" | passwd root
        sudo systemctl restart sshd
        sudo sh /vagrant_keys/config.sh
        sudo sh /vagrant_keys/generate_public_key.sh
        sudo sh /vagrant_keys/copy_keys.sh
        systemctl stop firewalld
      SHELL
    end
  end
end