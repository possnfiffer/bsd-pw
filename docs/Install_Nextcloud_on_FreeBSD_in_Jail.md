# Install Nextcloud on FreeBSD in a Jail
### in my lab my OPNSense firewall is also my DHCP server with the default gataway setup as 172.16.28.1, it also acts as my DNS

On the host machine run

```
vi /etc/sysctl.conf
```

add the contents

```
# Allow jail raw sockets
security.jail.allow_raw_sockets=1

# Allow upgrades in jail
security.jail.chflags_allowed=1
```

run the following

```
sysctl security.jail.allow_raw_sockets=1
```

```
sysctl security.jail.chflags_allowed=1
```

```
vi /boot/loader.conf
```

add the contents

```
# RACCT/RCTL Resource limits
kern.racct.enable=1
```

run the following

```
zfs create -o mountpoint=/jail zroot/jail
zfs create -o mountpoint=/jail/nextcloud zroot/jail/nextcloud
zfs create -o mountpoint=/jail/nextcloud/var/db/postgres/data -o recordsize=8k zroot/jail/nextcloud/pgsql
zfs get -r recordsize zroot/jail
```

```
fetch -o - http://ftp.freebsd.org/pub/FreeBSD/releases/amd64/12.0-RELEASE/base.txz | tar --unlink -xpJf - -C /jail/nextcloud
ls /jail/nextcloud
```

```
vi /etc/jail.conf
```

add the following configuration

```
nextcloud {
  host.hostname = nextcloud.lab.bsd.pw;
  ip4.addr = 172.16.28.2;
  interface = em0;
  path = /jail/nextcloud;
  exec.start = "/bin/sh /etc/rc";
  exec.stop = "/bin/sh /etc/rc.shutdown";
  exec.clean;
  mount.devfs;
  allow.raw_sockets;
  allow.sysvipc;
}
```

run the following

```
sysrc jail_enable=YES
sysrc jail_nextcloud_mount_enable=YES
vi /etc/hosts
```

add the following configuration

```
172.16.28.2 nextcloud.lab.bsd.pw nextcloud
```

run the following

```
jexec 1 tcsh
vi /etc/hosts
```

add the following configuration

```
172.16.28.2 nextcloud.lab.bsd.pw nextcloud
```

run the following

```
jexec 1 tcsh
newaliases -v
cp /usr/share/zoneinfo/America/Denver /etc/localtime
vi /etc/rc.conf
```

add the following configuration

```
# DAEMONS | yes
syslogd_flags="-s -s"
sshd_enable=YES
# php_fpm_enable=YES
# postgresql_enable=YES
# postgresql_class=postgres
# postgresql_data=/var/db/postgres/data
# memcached_enable=YES
# memcached_flags="-l 172.16.28.2"
# nginx_enable=YES

# DAEMONS | no
sendmail_enable=NONE
sendmail_submit_enable=NO
sendmail_outbound_enable=NO
sendmail_msp_queue_enable=NO

# OTHER
clear_tmp_enable=YES
clear_tmp_X=YES
extra_netfs_types=NFS
dumpdev=NO
update_motd=NO
keyrate=fast
```

run the following

```
vi /etc/cron.d/sendmail-clean-clientmqueue
```

add the following configuration

```
# CLEAN SENDMAIL
0 * * * * root /bin/rm -r -f /var/spool/clientmqueue/*
```

run the following

```
exit
service jail restart nextcloud
jls
jexec nextcloud tcsh
sockstat -l4
vi /etc/resolv.conf
```

add the following configuration

```
nameserver 172.16.28.1
```

run the following

```
ping -c 3 bsd.pw
exit
```

## Poudriere for building the postgres support we want

on the host machine run the following

```tcsh
pkg install -y poudriere
vi nextcloudpkglist
```

add the following configuration

```
www/nextcloud
www/nginx
databases/memcached
security/sudo
databases/postgresql10-server
www/php72-opcache
devel/php72-intl
mail/cclient
mail/php72-imap
math/php72-gmp
ftp/php72-ftp
```

run the following

```tcsh
vi /usr/local/etc/poudriere.d/amd64-12-0-make.conf
```

add the following configuration

```
DEFAULT_VERSIONS += php=7.2
DEFAULT_VERSIONS += pgsql=10
OPTIONS_UNSET += MYSQL
OPTIONS_SET += PGSQL
```

run the following

```tcsh
poudriere bulk -j amd64-12-0 -p head -f nextcloudpkglist
```

### Poudriere package repo nullfs mount inside jail upon jail start

run the following

```
service jail start nextcloud
jexec nextcloud tcsh
mkdir /mnt/amd64-12-0-head
exit
```

```
vi /etc/fstab.nextcloud
```

add the contents

```
/usr/local/poudriere/data/packages/amd64-12-0-head	/mnt/amd64-12-0-head	nullfs	rw	0	0
```

run the following

```
service jail restart nextcloud
jexec nextcloud tcsh
```

Create a pkg repository in the jail

```tcsh
mkdir -p /usr/local/etc/pkg/repos
```

Disable the main FreeBSD repo

```tcsh
vim /etc/pkg/FreeBSD.conf
```

Set enabled to no

```
FreeBSD: {
    enabled: no
}
```

Create a FreeBSD.conf replacement file to hold the repository configuration

```tcsh
vi /usr/local/etc/pkg/repos/amd64-12-0.conf
```

Add the following configuration

```
amd64-12-0: {
    url: “file:///mnt/amd64-12-0-head”,
    enabled: yes,
}
```

To reinstall all packages using the new repo

run the following

```
pkg upgrade -fy
pkg install -y www/nextcloud www/nginx databases/memcached security/sudo databases/postgresql10-server www/php72-opcache devel/php72-intl mail/cclient mail/php72-imap math/php72-gmp ftp/php72-ftp
```

## Updating Poudriere

from the host machine run the following

```tcsh
vim /usr/local/etc/poudriere.conf
```

```
CHECK_CHANGED_OPTIONS=verbose
CHECK_CHANGED_DEPS=yes
```

```tcsh
poudriere jail -j amd64-12-0 -u
```

```tcsh
poudriere ports -p head -u
poudriere bulk -j amd64-12-0 -p head -f nextcloudpkglist
```

from the jail update like

```tcsh
jexec nextcloud tcsh
pkg update && pkg upgrade -y
```

## Setting up PostgreSQL

run the following

```tcsh
```

(saving at this point, will continue working on this tutorial)
