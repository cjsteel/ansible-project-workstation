# HISTORY.md

## 2019-02-27- Added project testing using a Molecule provider

### On Host (Controller)

```shell
# move into your projects directory
cd ~/projects/workstation
# ensure your repository is up to date
git pull
# activate the projects virtual environment
source .venv/molecule/2.19.0/bin/activate
# install molecule
pip install molecule==2.19.0
```

### Initialize a new role using Molecule

```shell
cd ~/projects/workstation/roles/
molecule init role --role-name=common 
cd ~/projects/workstation/roles/common
molecule --debug create
```

### Test using the default (docker) scenario

```shell
# install molecule docker requirement(s)
pip install docker
# test provider creation
# ensure your in the roles main directory
cd ~/projects/workstation/roles/common
# do a create test
molecule --debug create
# run molecule test to destroy your instance
molecule --debug test
```

### Test with an lxd scenario

#### Create a new lxd scenario

```shell
# ensure your in the roles main directory
cd ~/projects/workstation/roles/common
# create your new scenario
molecule init scenario -s lxd -d lxd -r common
```

#### Edit scenario's playbook

```shell
nano molecule/lxd/playbook.yml 
```

Example content of `molecule/lxd/playbook.yml`

```shell

```

#### Test your new lxd scenario

##### Test provider instance creation
```shell
molecule --debug create -s lxd
```

##### Run `molecule converge -s lxd`

```shell
molecule --debug converge -s lxd
```

##### Log into instance

Manually log into your instance and confirm that the changes expected have been made. Run additional manual tests that can be incorporated into the called role(s) and add them to the called role(s) or a testing role(s) for the called role.

```shell
molecule login -s lxd
```

Example history of some manual testing of the geerlingguy.clamav role applied to our lxd molecule scenario. While sudo is not required when using LXD containers as the provider it is included here to be expicit as it would be required when using other providers such as the Vagrant/Virtualbox provider based scenario:

```shell
sudo systemctl status | grep clam
sudo systemctl stop clamav-daemon
sudo systemctl stop clamav-freshclam
sudo freshclam
exit
```

##### Destroy my lxd instance


```shell
molecule destroy -s lxd
```

## Adding common role to ansible-project-workstation

Next I add the common role (but not the other roles) to my ansible-project-workstation project so that I do not need to do this each time I start a similar project.

```shell
cd ~/projects/workstation
git status
```

Nothing shows up with my `git status` command so I edit my ~/.gitignore file and add `!roles/common` so that git can see my roles/common files.

```shell
roles/*
!roles/common
*.pyc
.venv
```

Then I run `git add` and check my git status to confirm the changes to my repository: 

```shell
git add .
git status
```

Output example:

```shell
On branch master
Your branch is up to date with 'origin/master'.

Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	modified:   .gitignore
	new file:   roles/common/.yamllint
	new file:   roles/common/README.md
	new file:   roles/common/defaults/main.yml
	new file:   roles/common/handlers/main.yml
	new file:   roles/common/meta/main.yml
	new file:   roles/common/molecule/default/Dockerfile.j2
	new file:   roles/common/molecule/default/INSTALL.rst
	new file:   roles/common/molecule/default/molecule.yml
	new file:   roles/common/molecule/default/playbook.yml
	new file:   roles/common/molecule/default/pytestdebug.log
	new file:   roles/common/molecule/default/tests/__pycache__/test_default.cpython-27-PYTEST.pyc
	new file:   roles/common/molecule/default/tests/test_default.py
	new file:   roles/common/molecule/default/tests/test_default.pyc
	new file:   roles/common/molecule/lxd/INSTALL.rst
	new file:   roles/common/molecule/lxd/molecule.yml
	new file:   roles/common/molecule/lxd/playbook.yml
	new file:   roles/common/molecule/lxd/pytestdebug.log
	new file:   roles/common/molecule/lxd/tests/__pycache__/test_default.cpython-27-PYTEST.pyc
	new file:   roles/common/molecule/lxd/tests/test_default.py
	new file:   roles/common/molecule/lxd/tests/test_default.pyc
	new file:   roles/common/tasks/main.yml
	new file:   roles/common/vars/main.yml
```

and commit and push my changes

```shell
git commit -m 'added common role to project for testing the project using molecule instances rather than directly on my system'


