#!/bin/bash -e

on_chroot << EOF
if ! docker -v
then
	#echo -e 'Package: docker-ce\nPin: version 18.06.*\nPin-Priority: 1000' > /etc/apt/preferences.d/docker-ce
	echo 'Installing Docker'
	curl -SsL https://get.docker.com | sh
fi

#docker pull nodered/node-red-docker:rpi

#echo 'Installing Docker Compose'
pip3 install docker-compose

# set default locales to 'en_US.UTF-8'
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen

echo 'locales locales/default_environment_locale select en_US.UTF-8' | debconf-set-selections
dpkg-reconfigure -f noninteractive locales
EOF
