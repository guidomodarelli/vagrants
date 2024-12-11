# Bugs

## macOS Monterrey 12.0.1 and VirtualBox 6.1.28

In macOS Monterrey 12.0.1 and VirtualBox 6.1.28 we have the following error when we run the command `vagrant up` in Wazuh Agent.

![docker](/public/assets/error-1-macOS.png)

You can fix it by following these steps

- Uninstall virtualBox 6.1.28 you can guide yourself with this reference [Uninstall virtualBox](https://nektony.com/how-to/uninstall-virtualbox-on-mac)
- Install VirtualBox 6.1.26, [download virtualBox 6.1.26](https://www.virtualbox.org/wiki/Download_Old_Builds_6_1)
- In the Vagrantfile add the following line `vb.gui = true` to enable the GUI. [Reference](https://www.vagrantup.com/docs/providers/virtualbox/configuration#gui-vs-headless)
- Run the command

```sh
sudo kextload -b org.virtualbox.kext.VBoxDrv;
sudo kextload -b org.virtualbox.kext.VBoxNetFlt;
sudo kextload -b org.virtualbox.kext.VBoxNetAdp;
sudo kextload -b org.virtualbox.kext.VBoxUSB;
```

- Finally run the command `vagrant up` again.

Original reference: <https://github.com/hashicorp/vagrant/issues/12557#issuecomment-956354353>

Original issue: <https://github.com/hashicorp/vagrant/issues/12557#issue-1036151651>
