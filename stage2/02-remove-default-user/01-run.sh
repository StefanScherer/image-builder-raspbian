#!/bin/bash -e

on_chroot << EOF
echo 'Removing default user pi'
rm -f /etc/sudoers.d/010_pi-nopasswd
deluser --remove-home pi
delgroup pi
systemctl enable ssh
EOF
