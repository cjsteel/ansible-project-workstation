#!/bin/bash

### Usage
#
# sudo ./init_ubuntu.sh

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

# ensure for projects directory

if [ -d ~/projects ] 
then
    echo "MESSAGE: Directory ~/projects exists." 
else
    echo "MESSAGE: Creating ~/projects directory." 
    mkdir -p ~/projects
    chown -R ${SUDO_USER}.${SUDO_USER} ~/projects
fi

# move into project parent directory

cd ~/projects

# ensure for project clone

if [ -d ~/projects/workstation ] 
then
    echo "MESSAGE: Directory ~/projects/workstation exists." 
else
    echo "MESSAGE: Cloning remote repository." 
    git clone https://github.com/cjsteel/ansible-project-workstation.git --recursive workstation
    chown -R ${SUDO_USER}.${SUDO_USER} ~/projects/workstation
fi

cd ~/projects/workstation

# ensure virtualenv is active

if [ -e .venv/molecule/2.19.0/bin/activate ]
then
    echo "MESSAGE: Activating virtualenv" 
    source ./.venv/molecule/2.19.0/bin/activate
else
    echo "virtualenv is not activated" 
fi

# install pip requirements for environment

.venv/molecule/2.19.0/bin/pip install molecule==2.19.0
# not sure why we need to reinstall ansible but we do
.venv/molecule/2.19.0/bin/pip uninstall -y ansible==2.7.8
.venv/molecule/2.19.0/bin/pip install ansible==2.7.8

#.venv/molecule/2.19.0/bin/pip install -r requirements.txt

# install ansible-galaxy requirements

.venv/molecule/2.19.0/bin/ansible-galaxy install -r requirements.yml

# run playbooks

ANSIBLE_NOCOWS=1 ansible-playbook -i inventory/localhost site.yml
