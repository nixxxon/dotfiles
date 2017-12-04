#!/bin/bash

if [ "$(dpkg -l "ansible" &> /dev/null)" != "" ]; then
  echo "Installing Ansible"
  sudo apt-add-repository -y ppa:ansible/ansible
  sudo apt-get update
  sudo apt-get install -y ansible
fi

echo "Applying Ansible playbooks"
sudo ansible-playbook -i "localhost," -c local ./playbooks/main.playbook.yml
