# ansible-project-workstation

DRAFT - ansible-project-workstation is for configuring personal workstations and notebooks

## Description

Project for configuring personal workstations and notebooks using ansible roles.

## Notes:

* run against localhost

## Project configuration

### Ensure for project structure

ensure for projects dir

```shell
mkdir ~/projects
cd ~/projects
```

### Clone current structure

```shell
git clone git@github.com:cjsteel/ansible-project-workstation.git 
workstation
```
### ensure for roles directory if testing all roles

```shell
mkdir roles
```

### ensure for inventory file

```shell
touch inventory
```

### Make any ansible.cfg edits

```shell
nano ansible.cfg
```

#### references for ansibe.cfg 
https://docs.ansible.com/ansible/2.4/intro_configuration.html#roles-path
https://docs.ansible.com/ansible/latest/reference_appendices/config.html

Example:

```shell
[defaults]
inventory=./inventory
roles_path=./roles
```

## Ensure for any virtualenv

```shell
pip install molecule==
```

output example:

```shell
1.20.1, 1.20.3, 1.21.1, 1.22.0, 1.23.0, 1.25.0, 1.25.1, 2.10.0, 2.10.1, 2.11.0, 2.12.0, 2.12.1, 2.13.0, 2.13.1, 2.14.0, 2.15.0, 2.16.0, 2.17.0, 2.18.0, 2.18.1, 2.19.0)
```
```shell
virtualenv ~/.venv/molecule/2.18.0 --python=python2.7
```

Activate

```shell
source ~/.venv/molecule/2.18.0/bin/activate
```

Install desired version of Molecule and dependent version of Ansible

```shell
pip install molecule==2.18.0
```

### Create new role

```shell
cd roles
molecule init role --role-name ansible-role-something
```

#### Initialize an LXD scenario

* https://linuxcontainers.org/lxd/getting-started-cli/

```shell
cd ansible-role-something
molecule init scenario -s lxd -d lxd --role-name ansible-role-something
```

test it using bionic VM

```shell
nano molecule/lxd/molecule.yml
```

Content example:

```shell
---
dependency:
  name: galaxy
driver:
  name: lxd
lint:
  name: yamllint
platforms:
  - name: something-bionic
    source:
      type: image
      mode: pull
      protocol: simplestreams
      alias: ubuntu/bionic/amd64
    architecture: x86_64
    config:
      limits.cpu: '4'
    devices:
      kvm:
        path: /dev/kvm
        type: unix-char
    profiles:
      - default
    force_stop: False
provisioner:
  name: ansible
  lint:
    name: ansible-lint
scenario:
  name: lxd
verifier:
  name: testinfra
  lint:
    name: flake8
```



```shell
molecule --debug create -s lxd
```

Ensure that container is actually 18.04

```shell
lxc file pull something-bionic/etc/lsb-release .
```

#### Ensure molecule is running correct lxd container OS

```shell
cat lsb-release
rm lsb-release
```

Desired output

```shell
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=18.04
DISTRIB_CODENAME=bionic
DISTRIB_DESCRIPTION="Ubuntu 18.04.2 LTS"
```

### Install any Ansible dependencies

## Adding Ansible Roles for Elsewhere

```shell
cd ~/projects/workstation/roles
```

### geerlingguy.clamav example:

Using ansible-galaxy

```shell
ansible-galaxy install geerlingguy.clamav
```

Using a git clone:



#### Ensure testing is working

Ensure for a default docker test:

```shell
cd ~/projects/workstation/roles
cd geerlingguy.clamav
molecule init scenario -s default -d docker --role-name=geerlingguy.clamav
```

Creating an LXC/LXD scenario:

```shell
molecule init scenario -s lxd -d lxd --role-name=geerlingguy.clamav
```

