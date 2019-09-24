#!/bin/bash -e

on_chroot << EOF
echo 'Installing Jupyter'
pip3 install \
  jupyter \
  jupyterlab \
  pipenv \
  readline \
  six \
  paho-mqtt \
  tweepy \
  ExpectException \
  psutil
pip3 download \
    ipyparallel \
    bash_kernel \
    ipython-sql \
    ihtml \
    RISE \
    jupyter_contrib_nbextensions \
#   ipyleaflet
EOF
