#!/bin/bash
set -e
scriptpath=$(cd $(dirname $0); pwd -P)
source "$scriptpath/versions.config"
VAGRANT_HOME=/home/vagrant
PI_GEN=$VAGRANT_HOME/deploy/pi-gen-docker
#Load pi-gen repro and change into it
source $scriptpath/build-source.sh

sed -i 's/FROM debian:stretch/FROM i386\/debian:stretch/g' $PI_GEN/Dockerfile

echo "Build image"
if [[ $(docker ps \
        --all \
        --filter "name=^pigen_work" \
        --format '{{.Names}}' ) == pigen_work ]]
then
  CONTINUE=1 ./build-docker.sh
else
  ./build-docker.sh
fi
ls -l deploy
cp --recursive --backup deploy $scriptpath/
if [ -d $VAGRANT_HOME/apt-cacher-ng ]
then
  rsync -av --delete $VAGRANT_HOME/apt-cacher-ng /vagrant/
fi
