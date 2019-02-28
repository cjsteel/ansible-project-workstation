# lxc-notes.md

## Running Docker in an LXC container

By default lxc/lxd containers are unprivileged. Here we create an LXD profile in order to allow for the creation of a privileged container that allows for (unlimited) container nesting.


## Resources

* https://blog.ubuntu.com/2015/10/30/nested-containers-in-lxd
* https://molecule.readthedocs.io/en/latest/configuration.html
* https://blog.ubuntu.com/2018/01/26/lxd-5-easy-pieces
* https://discuss.linuxcontainers.org/t/applying-security-privileged-via-profile-does-not-have-an-effect/2415

## Creating a custom lxd profie

### Manually configure a container to allow for nesting

Next we will manually configure a container and enable nesting. Launch an lxd container using the `lxc` command or using a molecule scenario using the lxd driver.

### Launch an lxd container

Using a molecule scenario using the lxd driver for a role that happens to be called  **common**. 

```shell
cd roles/common
molecule destroy -s lxd
molecule create -s lxd
```

### Get our containers name

Next we get the name of our launched container / instance:

```shell
molecule list
```

Output example:

```shell
Instance Name    Driver Name    Provisioner Name    Scenario Name    Created    Converged
---------------  -------------  ------------------  ---------------  ---------  -----------
instance         docker         ansible             default          false      false
docker-bionic    lxd            ansible             lxd              true       false
```

### Take a look at our containers default configuration

```shell
lxc config show docker-bionic
```

Content example:

```shell
architecture: x86_64
config:
  image.architecture: amd64
  image.build: "20190227_07:42"
  image.description: Ubuntu bionic amd64 (20190227_07:42)
  image.distribution: ubuntu
  image.name: ubuntu-bionic-amd64-default-20190227_07:42
  image.os: ubuntu
  image.release: bionic
  image.serial: "20190227_07:42"
  image.variant: default
  volatile.base_image: ebcf027d99bb3619d3d3e9ce142e74b00e8c2103069a4742e11da03f8eeb5f6b
  volatile.eth0.hwaddr: 00:16:3e:29:b1:9e
  volatile.idmap.base: "0"
  volatile.idmap.next: '[{"Isuid":true,"Isgid":false,"Hostid":165536,"Nsid":0,"Maprange":65536},{"Isuid":false,"Isgid":true,"Hostid":165536,"Nsid":0,"Maprange":65536}]'
  volatile.last_state.idmap: '[{"Isuid":true,"Isgid":false,"Hostid":165536,"Nsid":0,"Maprange":65536},{"Isuid":false,"Isgid":true,"Hostid":165536,"Nsid":0,"Maprange":65536}]'
  volatile.last_state.power: RUNNING
devices: {}
ephemeral: false
profiles:
- default
stateful: false
description: ""

```

### Configure container to allow for nesting

Stop our container using the `lxc stop` command:

```shell
lxc stop docker-bionic
```

Enable nesting for this container only with the following:

```shell
lxc config set docker-bionic security.nesting true
```

Restart our container

```shell
lxc start docker-bionic
```

### Take a look at our containers  configuration with nesting enabled

```shell
lxc config show docker-bionic
```

Content example shows that line `security.nesting: "true"` is now in the **config** section of our yaml output. We will add the line exactly as it is to a new profile that enables nesting.:

```shell
architecture: x86_64
config:
  image.architecture: amd64
  image.build: "20190227_07:42"
  image.description: Ubuntu bionic amd64 (20190227_07:42)
  image.distribution: ubuntu
  image.name: ubuntu-bionic-amd64-default-20190227_07:42
  image.os: ubuntu
  image.release: bionic
  image.serial: "20190227_07:42"
  image.variant: default
  security.nesting: "true"
  volatile.base_image: ebcf027d99bb3619d3d3e9ce142e74b00e8c2103069a4742e11da03f8eeb5f6b
  volatile.eth0.hwaddr: 00:16:3e:29:b1:9e
  volatile.idmap.base: "0"
  volatile.idmap.next: '[{"Isuid":true,"Isgid":false,"Hostid":165536,"Nsid":0,"Maprange":65536},{"Isuid":false,"Isgid":true,"Hostid":165536,"Nsid":0,"Maprange":65536}]'
  volatile.last_state.idmap: '[{"Isuid":true,"Isgid":false,"Hostid":165536,"Nsid":0,"Maprange":65536},{"Isuid":false,"Isgid":true,"Hostid":165536,"Nsid":0,"Maprange":65536}]'
  volatile.last_state.power: STOPPED
devices: {}
ephemeral: false
profiles:
- default
stateful: false
description: ""
```

The line we will put in our nested profile's config section:

```shell
  security.nesting: "true"
```

## Creating a new container profile

### Take a look at current lxd default profile

```shell
lxc profile show default
```

Note that our **config** section is empty:

```shell
config: {}
description: Default LXD profile
devices:
  eth0:
    name: eth0
    nictype: bridged
    parent: lxdbr0
    type: nic
  root:
    path: /
    pool: default
    type: disk
name: default
used_by:
- /1.0/containers/docker-bionic
```

### Create a new profile that enables nesting

We are going to enable nesting in a new profile called **nesting** rather than enabling nesting in our default profile. This way only the containers that need to have nesting enabled will have nesting enabled by applying both the ***default*** and ***nesting*** profiles to any containers that require nesting.

```shell
lxc profile create nesting
```

#### Example of edited nesting profile

The modified file should end up looking something like this:

```shell
config:
  security.nesting: "true"
description: "Default LXD profile"
devices: {}
name: nested

used_by: []
```

### Create the nesting profile

Next we will use the contents of `lxd-profile-nesting.yml` to create a new lxd profile called **nesting**

```shell
lxc profile create nesting
```

If all went well your should get a message like the following:

```shell
Profile nesting created
```

### Confirmation

```shell
lxc profile list
```

Output example:

```shell
+---------+---------+
|  NAME   | USED BY |
+---------+---------+
| default | 0       |
+---------+---------+
| nested  | 0       |
+---------+---------+
```



## Testing the nested profile

### Resources

Notice that in the `platforms` section of our `molecule.yml` file we have change the `profiles:` from the default setting of **- default** to be **- nested**:

```shell
---
dependency:
  name: galaxy
driver:
  name: lxd
lint:
  name: yamllint
platforms:
  - name: docker-bionic
    source:
      type: image
      alias: ubuntu/bionic/amd64
    architecture: x86_64
    profiles:
      - default
      - nested
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

### Create container

```shell
molecule --debug create -s lxd
```

### Check containers config

```shell
lxc config show docker-bionic 
```

Now our container if configured to use the default and nested profiles:

```shell
architecture: x86_64
config:
  image.architecture: amd64
  image.build: "20190227_07:42"
  image.description: Ubuntu bionic amd64 (20190227_07:42)
  image.distribution: ubuntu
  image.name: ubuntu-bionic-amd64-default-20190227_07:42
  image.os: ubuntu
  image.release: bionic
  image.serial: "20190227_07:42"
  image.variant: default
  volatile.base_image: ebcf027d99bb3619d3d3e9ce142e74b00e8c2103069a4742e11da03f8eeb5f6b
  volatile.eth0.hwaddr: 00:16:3e:8c:23:6c
  volatile.idmap.base: "0"
  volatile.idmap.next: '[{"Isuid":true,"Isgid":false,"Hostid":165536,"Nsid":0,"Maprange":65536},{"Isuid":false,"Isgid":true,"Hostid":165536,"Nsid":0,"Maprange":65536}]'
  volatile.last_state.idmap: '[{"Isuid":true,"Isgid":false,"Hostid":165536,"Nsid":0,"Maprange":65536},{"Isuid":false,"Isgid":true,"Hostid":165536,"Nsid":0,"Maprange":65536}]'
  volatile.last_state.power: RUNNING
devices: {}
ephemeral: false
profiles:
- default
- nested
stateful: false
description: ""
```

### Test with docker install to container

```shell
molecule converge -s lxd
```

Log into the container:

```shell
molecule login -s lxd 
```

Make the ubuntu user a member of the docker group (sudo used to imply this is done as root)

```shell
sudo usermod -aG docker ubuntu
```

Become the ubuntu user

```shell
su - ubuntu
```

Confim that the ubuntu user is in the docker group:

```shell
groups
```

run a docker container test:

```shell
docker run hello-world
```