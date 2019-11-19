#!/bin/bash
set -e

#if [[ ! $(docker ps \
#        --all \
#        --filter "name=^vagrant_apt-cacher-ng" \
#        --format '{{.Names}}' ) == deploy_apt-cacher-ng_1 ]]
#then
#  docker-compose --file $VAGRANT_HOME/deploy/docker-compose.yml up -d
#fi

echo "Cloning $PI_GEN_REPO"
if [ -d ${PI_GEN} ]
then
  sudo rm -rf ${PI_GEN}
fi
git clone "https://github.com/$PI_GEN_REPO" ${PI_GEN}
cd ${PI_GEN}
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

#Setting to 0 will deploy the actual image (.img)
#instead of a zipped image (.zip).
echo DEPLOY_ZIP=0 >> config

# Default system locale.
echo LOCALE_DEFAULT='"de_DE.UTF-8"' >> config


# Default keyboard keymap.
echo KEYBOARD_KEYMAP='"de"' >> config

# Default keyboard layout.
echo KEYBOARD_LAYOUT='"German (DE)"' >> config

# Timezone for german
echo TIMEZONE_DEFAULT='"Europe/Berlin"' >> config


echo "FIRST_USER_NAME=pirate" >> config
echo "FIRST_USER_PASS=hypriot" >> config

echo "ENABLE_SSH=1" >> config

cp -r $scriptpath/stage2/ .
#echo 'STAGE_LIST="stage0 stage1 stage2"' >> config
#touch stage3/SKIP
#touch stage4/SKIP
#touch stage4/SKIP_IMAGES
#rm -f stage4/EXPORT*
#touch stage5/SKIP
#touch stage5/SKIP_IMAGES
#rm -f stage5/EXPORT*
rm -f stage*/EXPORT_NOOBS
