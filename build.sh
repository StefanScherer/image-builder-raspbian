#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive
scriptpath=$(cd $(dirname $0); pwd -P)
source "$scriptpath/versions.config"
VAGRANT_HOME=/home/vagrant
PI_GEN=$VAGRANT_HOME/deploy/pi-gen
#Load pi-gen repro and change into it.
source $scriptpath/build-source.sh


echo "Build image"
sudo ./build.sh
ls -l $PI_GEN/deploy
cp --recursive --backup $PI_GEN/deploy $scriptpath/
if [ -d /var/cache/apt-cacher-ng ]
then
  rsync -av --delete /var/cache/apt-cacher-ng /vagrant/
fi
