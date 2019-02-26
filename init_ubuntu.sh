#!/bin/bash

# exit if a command fails
set -e

REPO=${ANSIBLE_PROJECT_REMOTE_REPO}
CLONE_DIR=${ANSIBLE_PROJECT_PARENT_DIR}/${ANSIBLE_PROJECT_LOCAL_REPO}

# install initial packages

apt update
apt install -y openssh-server
apt install -y git
apt install -y python-minimal
apt install -y python-pip

# clone this repo
mkdir -p ~/projects
cd ~/projects
git clone https://github.com/cjsteel/ansible-project-workstation.git --recursive workstation
chown -R ${SUDO_USER}.${SUDO_USER} ~/projects/workstation
cd workstation
source .venv/molecule/2.19.0/bin/activate
pip install -r requirements.txt
ansible-galaxy install -r requirements.yml
ANSIBLE_NOCOWS=1 ansible-playbook -i inventory/localhost site.yml
