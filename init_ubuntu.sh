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
mkdir -p "${ANSIBLE_PROJECT_PARENT_DIR}"
cd "${ANSIBLE_PROJECT_PARENT_DIR}"
git clone --recursive "${ANSIBLE_PROJECT_REMOTE_REPO}" "${ANSIBLE_PROJECT_LOCAL_REPO}"

# ensure for ansible
git clone https://github.com/ansible/ansible.git --recursive
cd ./ansible
source ansible/hacking/env-setup
sudo easy_install pip
sudo pip install -r requirements.txt
git pull --rebase.
ansible-galaxy install -r requirements.yml
#ANSIBLE_NOCOWS=1 ansible-playbook -i "${ANSIBLE_PROJECT_LOCAL_REPO}"/inventory/localhost "${ANSIBLE_PROJECT_LOCAL_REPO}"/site.yml

