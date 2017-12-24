#!/bin/bash
set -e

scriptpath=$(cd $(dirname $0); pwd -P)
source "$scriptpath/versions.config"

repo=RPi-Distro/pi-gen
tag=2017-11-29-raspbian-stretch

echo "Cloning $PI_GEN_REPO"
git clone "https://github.com/$PI_GEN_REPO" pi-gen
cd pi-gen
echo "Checkout $PI_GEN_TAG"
git checkout "$PI_GEN_TAG"
