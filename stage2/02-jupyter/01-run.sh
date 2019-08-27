#!/bin/bash -e

on_chroot << EOF
echo 'Installing Jupyter'
pip3 install \
  jupyter \
  jupyterlab \
  pipenv \
  six
EOF
