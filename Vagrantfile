# -*- mode: ruby -*-
# vi: set ft=ruby :

# vagrant-omnibus
# vagrant-berkshelf
# vagrant-ohai
# java -jar selenium-server-standalone.jar -role hub
# java -jar selenium-server-standalone.jar -role node -hub http://<hub-server>:4444/grid/register/
# nohup xvfb-run -a java -Xms512m -Xmx1024m -jar selenium-server-standalone.jar -role webdriver -hub http://<hub-server>:4444/grid/register -port 5556 -maxSession 10 -timeout 90 -browserTimeout 140
# nohup xvfb-run -a java -XX:MaxPermSize=128m -Xms1024m -Xmx1024m -jar selenium-server-standalone.jar -role webdriver -hub http://127.0.0.1:4444/grid/register -port 5555 -maxSession 15 -timeout 90 -browsetTimeout 140 -browser browserName=safari,maxInstances=5 -browser browserName=chrome,maxInstances=5 -Dwebdriver.chrome.driver=/usr/local/selenium/drivers/chromedriver -browser browserName=firefox,maxInstances=5 -browser browserName=opera,maxInstances=5
# http://<hub-server>:4444/grid/register/
# grid port 7055 must be open
#
# Error: Selenium is already running 5555 + 1

unless Vagrant.has_plugin?("vagrant-ohai")
  system('vagrant plugin install vagrant-ohai')
  raise("Plugin installed. Run command again.");
end

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "trusty64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 4444, host: 4444
  config.vm.network "forwarded_port", guest: 7055, host: 7055

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
    # Customize the amount of memory on the VM:
    #vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.memory = "2048"
    vb.cpus = 2
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # When Vagrant spins up a machine, it will also load your cookbook 
  # dependencies via Berkshelf
  
  config.berkshelf.enabled = true
  config.omnibus.chef_version = '11.8.2'
  config.berkshelf.berksfile_path = './Berksfile'

  # Chef node.json
  config.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = "/home/said/selenium/cookbook"
    chef.json = {
      "java" => {
        "install_flavor" => "oracle",
        "jdk_version" => "7",
        "oracle" => {
          "accept_oracle_download_terms" => true
        }
      },
      "selenium" => {
        "host" => "127.0.0.1",
        "jvm_args" => "-Xms256M -Xmx512M -XX:PermSize=256m -role hub"
      }
    }
    chef.add_recipe "java"
    chef.add_recipe "selenium::server"
    chef.add_recipe "selenium::chromedriver"
    chef.add_recipe "selenium::iedriver"
  end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y xvfb firefox chromium-chromedriver
  SHELL
end
