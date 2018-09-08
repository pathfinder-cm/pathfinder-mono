Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.network "private_network", ip: "192.168.33.33"

  config.vm.provider "virtualbox" do |vb|
     vb.memory = "2048"
  end

  config.vm.provision "shell", path: "bootstrap.sh"
end
