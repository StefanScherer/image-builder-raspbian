#!/bin/bash -e

on_chroot << EOF
echo 'Installing Docker'

if ! docker -v
then
	export DOCKER_MACHINE_VERSION="0.16.1"
	export DOCKER_COMPOSE_VERSION="1.21.1"
	#echo install docker-machine
	#curl -sSL -o /usr/local/bin/docker-machine \
	#	"https://github.com/docker/machine/releases/download/v${DOCKER_MACHINE_VERSION}/docker-machine-Linux-armhf"
	#chmod +x /usr/local/bin/docker-machine
	#echo install bash completion for Docker Machine
	#curl -sSL -o /etc/bash_completion.d/docker-machine \
	#	"https://raw.githubusercontent.com/docker/machine/v${DOCKER_MACHINE_VERSION}/contrib/completion/bash/docker-machine.bash"
	#echo install bash completion for Docker Compose
	#curl -sSL -o /etc/bash_completion.d/docker-compose \
	#	"https://raw.githubusercontent.com/docker/compose/${DOCKER_COMPOSE_VERSION}/contrib/completion/bash/docker-compose"

	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
	echo "deb [arch=armhf] https://download.docker.com/linux/raspbian buster stable" | tee /etc/apt/sources.list.d/docker.list
	apt-get update
	echo 'TODO Install docker-compose on native RaspberryPi would be better'
	apt-get install --no-install-recommends docker-ce docker-ce-cli containerd.io
	echo install bash completion for Docker CLI
	curl -sSL -o /etc/bash_completion.d/docker \
		"https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker"
	#docker pull hello-world
	#docker pull nodered/node-red-docker:rpi
fi

# set default locales to 'en_US.UTF-8'
#echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
#locale-gen

#echo 'locales locales/default_environment_locale select en_US.UTF-8' | debconf-set-selections
#dpkg-reconfigure -f noninteractive locales
EOF
