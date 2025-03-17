require_relative "./settings.rb"

# Shared Vagrant configuration utilities
# This file contains common configuration methods used across Vagrant VMs

module CommonConfig
  # Configure common settings for all VMs
  # @param config [Vagrant::Config::V2::Root] The Vagrant config object
  # @return [void]
  def self.config(config)
    # Disable SSH key insertion when running under WSL
    # This avoids key insertion issues that can occur in Windows Subsystem for Linux
    if ENV["VAGRANT_WSL"]
      config.ssh.insert_key = false
    end

    # Handle SSH public key provisioning if a key path is specified
    ssh_pub_key_path = ENV["WZ_SSH_PUB_KEY_PATH"]
    if ssh_pub_key_path
      ssh_dest_path = "/home/vagrant/.ssh/me.pub"
      # Copy the SSH public key to the VM
      config.vm.provision "file", source: ssh_pub_key_path, destination: ssh_dest_path
      # Add the public key to authorized_keys for both the vagrant user and root
      config.vm.provision "shell", inline: <<-SHELL
        authorized_keys_partial_path=".ssh/authorized_keys"
        cat #{ssh_dest_path} >> $HOME/${authorized_keys_partial_path}
        mkdir -p /root/.ssh/
        cat #{ssh_dest_path} >> /root/${authorized_keys_partial_path}
      SHELL
    end

    # Run provisioning scripts to configure SSH and disable firewall
    config.vm.provision "shell", path: "../__scripts__/enable-ssh.sh"
    config.vm.provision "shell", path: "../__scripts__/turn-off-firewalld.sh"
  end

  # Provider-specific configuration methods
  module Provider
    # Configure Hyper-V specific settings
    # @param config [Vagrant::Config::V2::Root] The Vagrant config object
    # @param hyperv [Object] The Hyper-V provider configuration object
    # @return [void]
    module HyperV
      def self.configure(config, hyperv)
        config.vm.network "public_network", bridge: "Default Switch"
        hyperv.maxmemory = SETTINGS["memory"]
        hyperv.cpus = SETTINGS["cpus"]
      end
    end

    # Configure VirtualBox specific settings
    # @param config [Vagrant::Config::V2::Root] The Vagrant config object
    # @param virtualbox [Object] The VirtualBox provider configuration object
    # @return [void]
    module VirtualBox
      def self.configure(config, virtualbox)
        virtualbox.memory = SETTINGS["memory"]
        virtualbox.cpus = SETTINGS["cpus"]
      end
    end
  end
end
