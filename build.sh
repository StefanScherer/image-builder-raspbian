#!/bin/bash
set -e

scriptpath=$(cd $(dirname $0); pwd -P)
source "$scriptpath/versions.config"

echo "Cloning $PI_GEN_REPO"
git clone "https://github.com/$PI_GEN_REPO" pi-gen
cd pi-gen
if [ ! -z "$PI_GEN_TAG" ]; then
  echo "Checkout $PI_GEN_TAG"
  git checkout "$PI_GEN_TAG"
fi

echo "Preparing build"
echo IMG_NAME='hypriotos' >config
cp -r ../stage2/ .
touch stage3/SKIP
touch stage4/SKIP
touch stage4/SKIP_IMAGES 
rm -f stage4/EXPORT*
touch stage5/SKIP
touch stage5/SKIP_IMAGES
rm -f stage5/EXPORT*

echo "Build image"
./build-docker.sh
ls -l deploy
