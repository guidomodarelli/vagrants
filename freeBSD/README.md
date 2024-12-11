# FreeBSD

## How to use

- Located at the same height as the Vagrantfile file, we execute `vagrant up`
  this will download the FreeBSD box and all the dependencies that are necessary to compile the Wazuh Agent will be installed, [Wazuh](https://github.com/wazuh/wazuh) source code is also downloaded, currently the version of the tag v4.2.2 is downloaded (check Vagrantfile to modify this last point)
- Once the installation process is finished we will have to enter the VM by executing the following command `vagrant ssh`
- Enter the folder wazuh `cd wazuh`
- Run the install script `sudo sh install.sh`
- Follow the installation steps.
- Ready we already have an Agent with FreeBSD
