# walkthrough.md

## Description

Written process of migrating from one workstation or notebook to another.

## Packing up

### Application data

### Dot files

#### ~/.gnupg

```shell
tar -zcvf gnupg.tar.gz ~/.gnupg
```

flags:

```txt
 -z, --gzip, --gunzip --ungzip

 -c, --create
       create a new archive

 -v, --verbose
       verbosely list files processed

 -f, --file ARCHIVE
       use archive file or device ARCHIVE
```

Restore:

```shell
tar -zxvf gnupg.tar.gz
```

#### ~/.ssh

#### ~/.password-store

