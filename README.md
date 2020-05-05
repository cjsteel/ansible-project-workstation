# ansible-project-workstation

## Description

Test project for configuring a workstations by bootstrapping an Ansible controller on the executing host

### Local Resources

* [docs/walkthrough.md](docs/walkthrough.md)

* [HISTORY.md](HISTORY.md)
* [ROADMAP.md](ROADMAP.md)

## Testing

**ATTENTION**

Executing these tests will make changes to your system including: 

* Ensuring for a ~/projects directory
* Ensuring for a clone of this project in ~/projects/workstation
* Bootstrapping a Python virtualenv based Ansible Controller with:
  * Molecule 2.19.0
  * Ansible

* Install all Ansible roles in the projects requirements.yml file

* Execute any roles in the projects `site.yml` file. - **You can avoid this last step by running `init_ubuntu.sh` instead of the `init-n-run_ubuntu.sh` script at the end of the curl command**

Examples:

```shell
cd
rm -rf ~/projects/workstation
```

Rerun from the start:

NOTE: If things are not progressing, press Enter once, you may be prompted for your sudo password.

```shell
sudo ls -al # force prompt for sudo a password
curl -k -L https://raw.githubusercontent.com/cjsteel/ansible-project-workstation/master/init-n-run_ubuntu.sh | sudo bash
```

Manual local testing

```shell
sudo ./init-n-run_ubuntu.sh
```

* run against localhost
## Configuration

You can add new Ansible roles by adding them to the projects requirements.yml and site.yml files

### requirements.yml

Currently actuates the installation of these fine ansible role(s).

```shell
# Install with: `ansible-galaxy install -r requirements.yml`

# from GitHub, overriding the name and specifying a specific tag
- src: https://github.com/geerlingguy/ansible-role-clamav.git
  version: 1.3.1
  name: geerlingguy.clamav
```

### site.yml

```shell
---
- hosts: "{{ host | default('localhost') }}"
  become: True
  roles:
    - geerlingguy.clamav
```
### ansible.cfg

You may also want to adjust the included **ansible.cfg** file

#### references for ansibe.cfg 

https://docs.ansible.com/ansible/2.4/intro_configuration.html#roles-path
https://docs.ansible.com/ansible/latest/reference_appendices/config.html

Current contents:

```shell
[defaults]
inventory=./inventory
roles_path=./roles
```

## Molecule testing

If you want to add a new role to your local install for testing or development you can do something like the following:

### Create new role

```shell
cd roles
molecule init role --role-name ansible-role-something
```

#### Initialize an LXC/LXD scenario

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

Ensure that container is actually 18.04, some glitches in 

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

## Adding Fine Ansible Roles from Elsewhere

If you want to add additional roles from other developers

### Installing ansible-galaxy roles

#### geerlingguy.clamav

Using ansible-galaxy while in the projects directory should install them to `~/projects/workstation/roles` due to the customizations in (the included ansible.cfg file.

```shell
ansible-galaxy install geerlingguy.clamav
```

##### Adding additional molecule testing to geerlingguy.clamav

Ensuring that the included testing is working (default docker scenario):

```shell
cd ~/projects/workstation/roles
cd geerlingguy.clamav
molecule init scenario -s default -d docker --role-name=geerlingguy.clamav
```

##### Creating a new LXC/LXD scenario:

```shell
molecule init scenario -s lxd -d lxd --role-name=geerlingguy.clamav
```

## Inspiration

### Andy Teng

* https://github.com/andytengca

### John Le

* https://github.com/johnle

### nix

* https://github.com/hostuser/ansible-workstation/blob/master/tasks/nix.yml

## To incorporate?

* https://github.com/geerlingguy/ansible-role-git
* https://github.com/geerlingguy/ansible-role-ansible/blob/master/defaults/main.yml
* https://github.com/jdauphant/ansible-role-spotify/blob/f135d7da65774cdab6e6cd2eb1d5436ebd467718/tasks/main.yml
* 
