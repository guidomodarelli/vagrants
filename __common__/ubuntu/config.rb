module Ubuntu
  def self.config(virtualbox)
    virtualbox.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end
end
