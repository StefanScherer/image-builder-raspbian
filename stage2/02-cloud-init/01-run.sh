#!/bin/bash -e

install -m 644 files/user-data ${ROOTFS_DIR}/boot/
install -m 644 files/meta-data ${ROOTFS_DIR}/boot/

on_chroot << EOF
echo 'Symlinking cloud-init nocloud-net seed files to /boot partition'
mkdir -p /var/lib/cloud/seed/nocloud-net
ln -s /boot/user-data /var/lib/cloud/seed/nocloud-net/user-data
ln -s /boot/meta-data /var/lib/cloud/seed/nocloud-net/meta-data
EOF
