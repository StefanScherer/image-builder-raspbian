# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  # Require the reboot plugin.
  #Vagrant.require_plugin "vagrant-reload"
  required_plugins = %w( vagrant-reload, vagrant-proxyconf)
  required_plugins.each do |plugin|
    system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
  end

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "file://builds/buster-10.1_rpibuilder-4_virtualbox.box"
  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.enabled = { yum: false, git: false, docker: false }
    config.apt_proxy.http     = "http://127.0.0.1:3142/"
    config.apt_proxy.https = "DIRECT"
  end
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  #config.vm.network "forwarded_port", guest: 3142, host: 33142

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

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
    # Display the VirtualBox GUI when booting the machine
    #vb.gui = true
    vb.cpus = 4

    # Customize the amount of memory on the VM:
    vb.memory = "8192"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    echo "Setup apt-cacher-ng"
    if [ -d /vagrant/apt-cacher-ng ]
    then
      rsync --archive --quiet /vagrant/apt-cacher-ng /var/cache/
      chown -R apt-cacher-ng: /var/cache/apt-cacher-ng
    fi
    echo "### Setup dns-server ###"
    sed -i 's/nameserver\s.*$/nameserver 9.9.9.9/g' /etc/resolv.conf
    export DEBIAN_FRONTEND=noninteractive
    echo "Update and upgrade debian system."
    apt-get update  >/dev/null
    apt-get dist-upgrade --yes  >/dev/null
    ls -ld /home/vagrant/deploy >/dev/null 2>&1 || mkdir -p /home/vagrant/deploy
    chown -R vagrant: /home/vagrant/deploy
    echo "Update ended. Rebooting system"
  SHELL

  # Run a reboot
  config.vm.provision :reload

  config.vm.provision "shell", inline: <<-SHELL
    echo "Remove not needed packages"
    export DEBIAN_FRONTEND=noninteractive
    export RPIGEN_DIR="${1:-/home/vagrant/rpi-gen}"
    export APT_PROXY='http://127.0.0.1:3142'
    apt-get autoremove --yes  >/dev/null
    echo "Install base packages"
    apt-get install --yes bash-completion git-core vim time >/dev/null

    echo "Install pi-gen dependencies"
    apt-get install --yes --quiet  coreutils quilt parted qemu-user-static \
        debootstrap zerofree zip dosfstools bsdtar libcap2-bin grep rsync \
        xz-utils file git curl debian-archive-keyring >/dev/null
    echo "Run pi-gen"
    modprobe binfmt_misc
    modprobe loop
    su --preserve-environment --command bash --command 'time LOCAL_APT_PROXY="$APT_PROXY" /vagrant/build.sh | tee /vagrant/build.log' vagrant
  SHELL
end
