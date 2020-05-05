#!/bin/bash

# Usage:
#
#   sudo ls -al # force prompt for sudo a password
#   curl -k -L https://raw.githubusercontent.com/cjsteel/ansible-project/master/bootstrap-ansible-project.sh | sudo bash
#   sudo ./bootstrap-ansible-project.sh
#

echo "$0 launched" 
# exit if a command fails
set -e

# VARS

ANSIBLE_VERSION=2.9.6

# REPO=${ANSIBLE_PROJECT_REMOTE_REPO}
# CLONE_DIR=${ANSIBLE_PROJECT_PARENT_DIR}/${ANSIBLE_PROJECT_LOCAL_REPO}

# install initial packages

sudo apt update
sudo apt install git
sudo apt install sshpass
sudo apt install openssh-server

# ensure for ansible venv

if [ -d ~/.venv/ansble-${ANSIBLE_VERSION} ]
then
    echo "MESSAGE: Directory ~/.venv/ansble-${ANSIBLE_VERSION} exists."
else
    echo "Ensure that python3-venv is installed"
    sudo apt update
    sudo apt install python3-venv -y
    echo "Creating venv ~/.venv/ansble-${ANSIBLE_VERSION}"
    python3 -m venv ~/.venv/ansble-${ANSIBLE_VERSION}
    source ~/.venv/ansble-${ANSIBLE_VERSION}/bin/activate
    pip3 install ansible==${ANSIBLE_VERSION}
    ansible --version
fi

# ensure for bash_magic

if [ -d ~/bin/bash_magic ]
then
    echo "MESSAGE: ~/bin/bash_magic exists."
else
    echo "Clone bash_magic to ~/bin"
    mkdir ~/bin
    cd ~/bin
    git clone https://github.com/cjsteel/bash_magic.git
    cat ~/bin/bash_magic/bashrc >> ~/.bashrc
    mkdir ~/.bash_aliases.d ~/.bash_completion.d ~/.bash_functions.d
    echo "alias ansible-${ANSIBLE_VERSION}='source ~/.venv/ansble-${ANSIBLE_VERSION}/bin/activate'" > ~/bin/bash_magic/bash_aliases.d/ansible-2.9.6.sh 
    ln -s /bin/bash_magic/bash_aliases.d/ansible-${ANSIBLE_VERSION}.sh ~/.bash_aliases.d/ansible-${ANSIBLE_VERSION}.sh
fi

# ensure for projects directory

#if [ -d ~/projects ]
#then
#    echo "MESSAGE: Directory ~/projects exists."
#else
#    echo "MESSAGE: Creating ~/projects directory."
#    mkdir -p ~/projects
#    chown -R ${SUDO_USER}.${SUDO_USER} ~/projects
#fi

# move into project parent directory

#cd ~/projects

# ensure for project clone

#if [ -d ~/projects/ansible-project ]
#then
#    echo "MESSAGE: Directory ~/projects/ansible-project exists." 
#else
#    echo "MESSAGE: Cloning remote repository." 
#    git clone https://github.com/cjsteel/ansible-project.git --recursive
#    chown -R ${SUDO_USER}.${SUDO_USER} ~/projects/workstation
#fi

#cd ~/projects/workstation

# ensure for virtualenv

#if [ -d ~/projects/workstation/.venv ] 
#then
#    echo "MESSAGE: Directory ~/projects/workstation/.venv exists." 
#else
#    echo "MESSAGE: Creating virtualenv." 
#    virtualenv .venv/molecule/2.19.0 --python=python2.7 --no-site-packages
#    chown -R ${SUDO_USER}.${SUDO_USER} ~/projects/workstation/.venv
#fi


# ensure virtualenv is active

#if [ -e .venv/molecule/2.19.0/bin/activate ]
#then
#    echo "MESSAGE: Activating virtualenv"
#    source .venv/molecule/2.19.0/bin/activate
#else
#    echo "virtualenv is not activated" 
#fi

# install pip requirements for environment

#.venv/molecule/2.19.0/bin/pip install molecule==2.19.0
#chown -R ${SUDO_USER}.${SUDO_USER} ~/projects/workstation/.venv

# not sure why we need to reinstall ansible but we do
#.venv/molecule/2.19.0/bin/pip uninstall -y ansible==2.7.8
#.venv/molecule/2.19.0/bin/pip install ansible==2.7.8
#chown -R ${SUDO_USER}.${SUDO_USER} ~/projects/workstation/.venv

#.venv/molecule/2.19.0/bin/pip install -r requirements.txt

# install ansible-galaxy requirements

#.venv/molecule/2.19.0/bin/ansible-galaxy install -r requirements.yml
#chown -R ${SUDO_USER}.${SUDO_USER} ~/projects/workstation/roles

# run playbooks

#ANSIBLE_NOCOWS=1 ansible-playbook -i inventory/localhost site.yml
