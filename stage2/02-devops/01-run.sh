#!/bin/bash -e

on_chroot << EOF
echo 'Installing Ansible'
pip3 install ansible \
  paho-mqtt \
  tweepy \
  psutil

echo 'Get selenium'
pip3 install selenium \
  pyvirtualdisplay

su --login --command 'git clone -b master https://kraeml@gitlab.com/kraeml/raspberry-edu-devops.git ~/.raspberry-edu-devops || (cd ~/.raspberry-edu-devops; git pull)' pi
su --login --command 'cd ~/.raspberry-edu-devops/; mkdir roles || true; ansible-galaxy install --force --role-file=requirements.yml' pi
#su --login --command 'ansible-playbook --inventory ~/.raspberry-edu-devops/hosts --limit lokal ~/.raspberry-edu-devops/site.yml' pi
#TODO not running because wrong hostname
#su --login --command 'ansible-playbook --inventory ~/.raspberry-edu-devops/hosts --limit $(hostname) ~/.raspberry-edu-devops/site.yml' pi
EOF
