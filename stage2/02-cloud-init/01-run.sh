#!/bin/bash -e

install -m 644 files/user-data ${ROOTFS_DIR}/boot/
install -m 644 files/meta-data ${ROOTFS_DIR}/boot/
install -m 644 files/cloud/cloud.cfg ${ROOTFS_DIR}/etc/cloud/

on_chroot << EOF
echo 'Get cloud-init'

echo 'Symlinking cloud-init nocloud-net seed files to /boot partition'
mkdir -p /var/lib/cloud/seed/nocloud-net
if [ ! -f /var/lib/cloud/seed/nocloud-net/user-data ]
then
  ln -s /boot/user-data /var/lib/cloud/seed/nocloud-net/user-data
fi
if [ ! -f /var/lib/cloud/seed/nocloud-net/meta-data ]
then
  ln -s /boot/meta-data /var/lib/cloud/seed/nocloud-net/meta-data
fi
if [ -n "${FIRST_USER_NAME}" ]
then
  sed -i "s/name: pi$/name: ${FIRST_USER_NAME}/g" /etc/cloud/cloud.cfg
  sed -i "s/#sudo:/sudo:/g" /etc/cloud/cloud.cfg
fi
mkdir /boot/cloud
mv /etc/cloud/templates /boot/cloud/templates
#sed -i "s,/etc/cloud/templates/,/boot/cloud/templates/,g" /etc/cloud/cloud.cfg
ln -s /boot/cloud/templates /etc/cloud/templates
EOF

# Workaround for pi-hole
install -m 644 files/cloud/templates/hosts.debian.tmpl ${ROOTFS_DIR}/boot/cloud/templates/
