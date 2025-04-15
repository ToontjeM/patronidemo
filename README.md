# Patroni demo

This demo is deployed using Vagrant and will deploy the following nodes: 

![Cluster](images/cluster.png)

| Name | IP | Task | Remarks |
| -------- | ----- | -------- | -------- |
| c | 192.168.56.10 | Console | Workstation |
| p1 | 192.168.56.11 | Postgres Primary |  |
| p2 | 192.168.56.12 | Postgres Standby |  |
| p3 | 192.168.56.13 |  Postgres Standby |  |
| e1 | 192.168.56.21 | Etcd node |  |
| e2 | 192.168.56.22 | Etcd node |  |
| e3 | 192.168.56.23 | Etcd node |  |
| h1 | 192.168.56.31 | HA Proxy |  |
| h2 | 192.168.56.32 | HA Proxy |  |

## Demo prep
### Pre-requisites
To deploy this demo the following needs to be installed in the PC from which you are going to deploy the demo:

- VirtualBox (https://www.virtualbox.org/)
- Vagrant (https://www.vagrantup.com/)
- Vagrant Hosts plug-in (`vagrant plugin install vagrant-hosts`)
- Vagrant Reload plug-in (`vagrant plugin install vagrant-reload`)
- A file called `.edb_subscription_token` with your EDB repository 2.0 token in your `$HOME/token` directory. 
This token can be found in your EDB account profile here: https://www.enterprisedb.com/accounts/profile

The environment is deployed in a VirtualBox network. Please check if the private network in your VirtualBox setup is `192.168.56.0`.

### Provisioning
Provision the demo environment like always using `00-provision.sh`.

After provisioning, the hosts will have their regular directory mounts as defined in the `Vagrantfile`:
```
  config.vm.synced_folder ".", "/vagrant"
  config.vm.synced_folder "./scripts", "/scripts"
  config.vm.synced_folder "./config", "/config"
  config.vm.synced_folder "#{ENV['HOME']}/tokens", "/tokens"
```
## Demo flow
- SSH into the console using `vagrant ssh console`
