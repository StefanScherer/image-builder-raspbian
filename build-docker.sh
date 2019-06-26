#!/bin/bash
set -e

scriptpath=$(cd $(dirname $0); pwd -P)
source "$scriptpath/versions.config"

echo "Cloning $PI_GEN_REPO"
if [ -d pi-gen ]
then
  rm -rf pi-gen
fi
git clone "https://github.com/$PI_GEN_REPO" pi-gen
cd pi-gen
if [ ! -z "$PI_GEN_TAG" ]; then
  echo "Checkout $PI_GEN_TAG"
  git checkout "$PI_GEN_TAG"
fi

echo "Preparing build"
echo IMG_NAME='hypriotos-devops-acadamy' >config
# e.g. LOCAL_APT_PROXY="http://YOUR_FQDN:3142" ./build.sh
if [ ! -z "$LOCAL_APT_PROXY" ]
then
  echo "APT_PROXY=$LOCAL_APT_PROXY" >> config
fi
if [ ! -z "$LOCAL_PIP_PROXY" ]
then
  echo "PIP_PROXY=$LOCAL_PIP_PROXY" >> config
fi
echo "FIRST_USER_NAME=pirate" >> config
echo "FIRST_USER_PASS=hypriot" >> config
echo "ENABLE_SSH=1" >> config
#echo 'STAGE_LIST="stage0 stage1 stage2"' >> config
cp -r ../stage2/ .
#touch stage3/SKIP
#touch stage4/SKIP
#touch stage4/SKIP_IMAGES
#rm -f stage4/EXPORT*
#touch stage5/SKIP
#touch stage5/SKIP_IMAGES
#rm -f stage5/EXPORT*

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
