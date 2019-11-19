#!/bin/bash -e

on_chroot << EOF
git clone https://github.com/thekroko/icotools.git
cd icotools/examples/icezero/
make icezprog
make install_icezprog
cd
git clone https://github.com/thekroko/icezero-blinky.git
#cd icezero-blinky/
#icezprog blinky.bin
EOF
