# -*- mode: ruby -*-
# vi: set ft=ruby :

# VM
var_box            = "bento/almalinux-9.5"
var_box_version    = "202502.21.0"

Vagrant.configure("2") do |config|

  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  # Box
  config.vm.box = var_box
  config.vm.box_version = var_box_version

  # Share files
  #config.vm.synced_folder ".", "/vagrant", type: "rsync"
  #config.vm.synced_folder "./scripts", "/scripts", type: "rsync"
  #config.vm.synced_folder "./config", "/config", type: "rsync"
  #config.vm.synced_folder "#{ENV['HOME']}/tokens", "/tokens", type: "rsync"
  config.vm.synced_folder ".", "/vagrant"
  config.vm.synced_folder "./scripts", "/scripts"
  config.vm.synced_folder "./config", "/config"
  config.vm.synced_folder "#{ENV['HOME']}/tokens", "/tokens"
  config.vm.provision :hosts, :sync_hosts => true

  # Bootstrap for all nodes
  config.vm.provision "shell", path: "scripts/bootstrap_all.sh"
  

#  config.vm.define "c" do |nodes|
#    nodes.vm.box = var_box
#    nodes.vm.hostname= "c"
#    nodes.vm.network "private_network", ip: "192.168.56.10"
#    nodes.vm.provider "virtualbox" do |v|
#      v.memory = "512"
#      v.cpus = "1"
#      v.name = "c"
#    end
#    nodes.vm.provision "shell", path: "scripts/bootstrap_c.sh"
#  end

  # Etcd
  (1..3).each do |i|
    config.vm.define "e#{i}" do |nodes|
      nodes.vm.box = var_box
      nodes.vm.hostname = "e#{i}"
      nodes.vm.network "private_network", ip: "192.168.56.2#{i}"
      nodes.vm.provider "virtualbox" do |v|
        v.memory = "512"
        v.cpus = "1"
        v.name = "e#{i}"
      end
      nodes.vm.provision "shell", path: "scripts/bootstrap_e#{i}.sh"
    end
  end

#  # Postgres Nodes
#  (1..3).each do |i|
#    config.vm.define "p#{i}" do |nodes|
#      nodes.vm.box = var_box
#      nodes.vm.hostname = "p#{i}"
#      nodes.vm.network "private_network", ip: "192.168.56.1#{i}"
#      nodes.vm.provider "virtualbox" do |v|
#        v.memory = "1024"
#        v.cpus = "2"
#        v.name = "p#{i}"
#      end
#      nodes.vm.provision "shell", path: "scripts/bootstrap_p#{i}.sh"
#    end
#   end

#   # HA Proxies
#  (1..2).each do |i|
#    config.vm.define "h#{i}" do |nodes|
#      nodes.vm.box = var_box
#      nodes.vm.hostname = "h#{i}"
#      nodes.vm.network "private_network", ip: "192.168.56.3#{i}"
#      nodes.vm.provider "virtualbox" do |v|
#        v.memory = "512"
#        v.cpus = "1"
#        v.name = "h#{i}"
#      end
#      nodes.vm.provision "shell", path: "scripts/bootstrap_h#{i}.sh"
#    end
#  end
end