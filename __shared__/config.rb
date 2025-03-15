def common_config(config)
  if ENV["VAGRANT_WSL"]
    config.ssh.insert_key = false
  end
  ssh_pub_key_path = ENV["WZ_SSH_PUB_KEY_PATH"]
  if ssh_pub_key_path
    ssh_dest_path = "~/.ssh/me.pub"
    config.vm.provision "file", source: ssh_pub_key_path, destination: ssh_dest_path
    config.vm.provision "shell", inline: <<-SHELL
      authorized_keys_partial_path=".ssh/authorized_keys"
      cat #{ssh_dest_path} >> $HOME/${authorized_keys_partial_path}
      mkdir -p /root/.ssh/
      cat #{ssh_dest_path} >> /root/${authorized_keys_partial_path}
    SHELL
  end
end
