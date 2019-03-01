# adding-new-roles-to-the-project.md

## Description

How to add new roles to this project

## For testing only

### requirements.yml

Add the role, release and any other information allowed/required to the projects `requirements.yml` file.

#### requirements.yml example

```shell
# You can manually install with: `ansible-galaxy install -r requirements.yml`

- src: https://github.com/weareinteractive/ansible-users
  version: 1.11.1
  name: weareinteractive.users

- src: https://github.com/geerlingguy/ansible-role-pip.git
  version: 1.3.0
  name: geerlingguy.pip

- src: https://github.com/geerlingguy/ansible-role-clamav.git
  version: 1.3.1
  name: geerlingguy.clamav
  
- src: https://github.com/geerlingguy/ansible-role-docker.git
  version: 2.5.2
  name: geerlingguy.docker

- src: https://github.com/jdauphant/ansible-role-vagrant
  version: 1.1
  name: jdauphant.vagrant
```

### projects/workstation/roles/common/molecule/lxd/playbook.yml

To test usinga molecule scenario add the role and any variables to the **common** roles molecule scenario(s) of your choice.

#### molecule/{{ some_scenario }}/playbook.yml example:

You could also use the Ansible [include_role module](https://docs.ansible.com/ansible/latest/modules/include_role_module.html) to load and execute the [geerlingguy.pip](https://github.com/geerlingguy/ansible-role-pip.git) when required by other roles but in order to keep things very explicite I am going to attempt to install pip requirements for various roles by repeatedly running the pip role before the role requiring a particular pip install python module or library. 

```shell
---
# projects/workstation/roles/common/molecule/lxd/playbook.yml
- name: Converge
  hosts: all
  vars:
    users:
      - username: ubuntu
        groups:
          - docker
        append: yes
   vagrant_version: "2.2.3"

  roles:
    - role: common
    - role: geerlingguy.clamav
    - { name: "Install the Python docker library which is required",
        role: geerlingguy.pip, pip_install_packages: docker }
    - role: geerlingguy.docker
    - role: weareinteractive.users
    - role: jdauphant.vagrant
```

### Testing your changes

#### reinitialize the project

```shell
cd ~/projects/workstation
sudo ./init_ubuntu.sh
```

#### run your molecule tests in the common role directory

```shell
cd ~/projects/workstation/role/
molecule converge -s lxd
```

#### Manual testing on target container

Login

```shell
molecule login -s lxd
```

Ensure Docker is working

```shell
pip freeze
docker run hello-world
```

Setup a virtualenv

```shell

