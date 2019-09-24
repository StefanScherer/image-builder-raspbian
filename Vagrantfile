# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  # Require the reboot plugin.
  #Vagrant.require_plugin "vagrant-reload"
  required_plugins = %w( vagrant-reload vagrant-persistent-storage )
  required_plugins.each do |plugin|
    system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
  end

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "bento/ubuntu-19.04"
  #config.vm.box = "bento/debian-10.0-i386"
  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.enabled = { yum: false, git: false, docker: false }
    config.apt_proxy.http     = "http://192.168.56.216:3142/"
    #config.proxy.https    = "http://192.168.0.2:3128/"
    #config.proxy.no_proxy = "localhost,127.0.0.1,.example.com"
    config.apt_proxy.https = "DIRECT"
  end
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end
  config.persistent_storage.enabled = true
  config.persistent_storage.location = "./pigenhdd.vdi"
  config.persistent_storage.size = 150000
  config.persistent_storage.mountname = 'pigen'
  config.persistent_storage.filesystem = 'ext4'
  config.persistent_storage.mountpoint = '/home/vagrant/deploy'

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  config.vm.network "forwarded_port", guest: 3142, host: 33142

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
    export DEBIAN_FRONTEND=noninteractive
    #Setup locale for raspberry installer
    locale-gen en_GB.UTF-8
    update-locale LANG=en_GB.UTF-8
    update-locale LANGUAGE=en_GB.UTF-8
    update-locale LC_CTYPE=en_GB.UTF-8
    update-locale LC_ALL=en_GB.UTF-8
    dpkg-reconfigure locales >/dev/null

    echo "Update and upgrade ubuntu system."
    apt-get update  >/dev/null
    apt-get dist-upgrade --yes  >/dev/null
    chown -R vagrant: /home/vagrant/deploy
    echo "Update ended. Rebooting system"
  SHELL

  # Run a reboot
  config.vm.provision :reload

  config.vm.provision "shell", inline: <<-SHELL
    export DEBIAN_FRONTEND=noninteractive
    apt-get autoremove --yes  >/dev/null
    #install base packages not in bentu/ubuntu-19.04
    apt-get install --yes bash-completion git-core vim >/dev/null

    #dependencies for pi-gen build.sh
    #**(*) Warning:** please note that there is currently an issue when building with the
    #64-bits version of the `qemu-user-static` package. As a workaround, you can use the
    #32-bits `qemu-user-static:i386` package instead.
    #
    #To do this, first add the `i386` architecture to your Debian-based system:
    #
    #```bash
    #dpkg --add-architecture i386
    #apt-get update
    #```
    #
    #Then replace `qemu-user-static` with `qemu-user-static:i386` in the instructions above.
    #
    #Also note that the included Dockerfile in pi-gen already includes this workaround.
    #
    #For more info refer to: https://github.com/RPi-Distro/pi-gen/issues/271
    dpkg --add-architecture i386
    apt-get update >/dev/null
    apt-get install --yes --quiet  coreutils quilt parted qemu-user-static:i386 \
        debootstrap zerofree zip dosfstools bsdtar libcap2-bin grep rsync \
        xz-utils file git curl debian-archive-keyring >/dev/null
    #Install Docker
    apt-get install --yes --quiet apt-transport-https ca-certificates curl gnupg2 \
        software-properties-common >/dev/null
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
    # disco not in docker repro $(lsb_release -cs) replaced wiht cosmic
    add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable" >/dev/null
    apt-get update >/dev/null
    apt-get install --yes --quiet docker-ce docker-ce-cli containerd.io \
        docker-compose >/dev/null
    # docker run hello-world
    usermod -aG docker vagrant

    #Setup and start apt-cacher-ng with docker-compose
    PIGEN_DEPLOY=/home/vagrant/deploy
    rsync --archive --checksum --quiet /vagrant/docker-compose.yml $PIGEN_DEPLOY/
    # TODO: Set up rights systemd-network:root 755 dirs and 655 files
    if [ -d /vagrant/apt-cacher-ng ]
    then
      rsync --archive --checksum --delete --quiet /vagrant/apt-cacher-ng $PIGEN_DEPLOY/
    fi
    if [[ ! $(docker ps \
            --all \
            --filter "name=^vagrant_apt-cacher-ng" \
            --format '{{.Names}}' ) == vagrant_apt-cacher-ng_1 ]]
    then
      cd $PIGEN_DEPLOY
      docker-compose --file $PIGEN_DEPLOY/docker-compose.yml up -d
    fi
    sed -i 's/nameserver\s.*$/nameserver 9.9.9.9/g' /etc/resolv.conf
    su --command bash --command 'LOCAL_APT_PROXY="http://172.17.0.1:3142" time /vagrant/build.sh | tee /vagrant/build.log' vagrant
    if [ -d $PIGEN_DEPLOY/apt-cacher-ng ]
    then
      rsync --archive --checksum --delete --quiet $PIGEN_DEPLOY/apt-cacher-ng /vagrant/
    fi
    #
  SHELL
end
