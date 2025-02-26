# Vagrants

The images from [roboxes.org](https://roboxes.org/) o [HashiCorp
Generic](https://portal.cloud.hashicorp.com/vagrant/discover/generic) support
multiple virtualizers, including Hyper-V. I often use their boxes because they
are compatible with Windows, Linux, and macOS, as well as their respective
operating systems.

## Copy from Host to Guest
```bash
scp <file> vagrant@192.168.56.9:/path/to/destination
```

## Copy from Guest to Host
```bash
scp vagrant@192.168.56.9:/path/on/guest/file /path/on/host
```

Note: Replace the IP address with your VM's actual IP address

## Helpful Commands

### Vagrant

- `vagrant up` This command creates and configures guest machines according to
  your Vagrantfile. [For more Info.](https://www.vagrantup.com/docs/cli/up)
- `vagrant halt` This command shuts down the running machine Vagrant is
  managing. [For more Info.](https://www.vagrantup.com/docs/cli/halt)
- `vagrant destroy` This command stops the running machine Vagrant is managing
  and destroys all resources that were created during the machine creation
  process. [For more Info.](https://www.vagrantup.com/docs/cli/destroy)
- `vagrant ssh` This will SSH into a running Vagrant machine and give you access
  to a shell. [For more Info.](https://www.vagrantup.com/docs/cli/ssh)
- `vagrant status` This will tell you the state of the machines Vagrant is
  managing. [For more Info.](https://www.vagrantup.com/docs/cli/status)
