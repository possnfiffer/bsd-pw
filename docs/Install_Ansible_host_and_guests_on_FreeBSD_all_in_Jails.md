# Install Ansible host and guests on FreeBSD all in Jails
## Currently working on turning this into an Ansible Playbook =D, I also just ordered the book FreeBSD Mastery Jails from mwl.io which will be very helpful
### in my lab I use an OPNSense firewall which is also my DHCP server with the default gataway setup as 172.16.28.1, it also acts as my DNS. Below we will be using zroot as the name of the zpool.

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
zfs create -o mountpoint=/jail/ansible0 zroot/jail/ansible0
```

```
fetch -o - http://ftp.freebsd.org/pub/FreeBSD/releases/amd64/12.0-RELEASE/base.txz | tar --unlink -xpJf - -C /jail/ansible0
ls /jail/ansible0
```

```
vi /etc/jail.conf
```

add the following configuration

```
ansible0 {
  host.hostname = ansible0.lab.bsd.pw;
  ip4.addr = 172.16.28.10;
  interface = em0;
  path = /jail/ansible0;
  exec.start = "/bin/sh /etc/rc";
  exec.stop = "/bin/sh /etc/rc.shutdown";
  exec.clean;
  mount.devfs;
  allow.raw_sockets;
  sysvsem = new;
  sysvshm = new;
  sysvmsg = new;
}
```

run the following

```
sysrc jail_enable=YES
sysrc jail_ansible0_mount_enable=YES
service jail restart ansible0
jexec 1 tcsh
vi /etc/resolv.conf
```

add the following DNS configuration

```
nameserver 172.16.28.1
```

run the following

```
ping -c 3 bsd.pw
adduser
```

here's what I typed

```
root@ansible0:/ # adduser
Username: ansible
Full name: Ansible user
Uid (Leave empty for default): 
Login group [ansible]: 
Login group is ansible. Invite ansible into other groups? []: wheel
Login class [default]: 
Shell (sh csh tcsh nologin) [sh]: tcsh
Home directory [/home/ansible]: 
Home directory permissions (Leave empty for default): 
Use password-based authentication? [yes]: 
Use an empty password? (yes/no) [no]: 
Use a random password? (yes/no) [no]: 
Enter password: 
Enter password again: 
Lock out the account after creation? [no]: 
Username   : ansible
Password   : *****
Full Name  : Ansible user
Uid        : 1001
Class      : 
Groups     : ansible wheel
Home       : /home/ansible
Home Mode  : 
Shell      : /bin/tcsh
Locked     : no
OK? (yes/no): yes
```

```
pkg install -y sudo python37
visudo
/wheel (press Enter)
j0xxZZ (on first search of wheel, j goes down a line, 0 to the start of a line, xx to delete comment, ZZ to save and quit)
su ansible
cd
sudo -H python3.7 -m ensurepip
sudo -H pip3.7 install pipenv
mkdir ansible
cd ansible
vi hosts
```

add the following configuration

```
[local]
127.0.0.1 ansible_python_interpreter=/usr/local/bin/python3.7 ansible_connection=local
```

run the following
```
pipenv install ansible
pipenv shell
ansible local -i hosts -m setup
ansible local -i hosts -m pkgng -a "name=git-lite state=present" -bK
```

weird... the above fails inside my jail machine but when I setup the same thing on my real hardware setup it works fine and adds the package... jail gets an error and says "Could not update catalogue"

I should setup my jail as a target for Ansible.

```
sudo -i
sysrc sshd_enable=YES
service sshd start
vi /etc/ssh/sshd_config
```

change the ListenAddress to be the IP of the jail
also add a new line to the end of the file that shows the following configuration

```
AllowUsers ansible
```

run the following
```
service sshd restart
exit
mkdir .ssh
vi .ssh/authorized_keys
```

authorized_keys should include the output of cat ansible.pub (whatever you named your ssh key pair) on a line of it's own




From here on out I'm on my regular FreeBSD laptop running commands. 

```
vi ansible.cfg
```

add the following
```
[defaults]
inventory = hosts
remote_user = ansible
```

no need to keep typing `-i hosts`

back to the jail (we may not need to have ansible in the group wheel anymore...something to consider)

```
pw groupadd sudo
pw groupmod sudo -m ansible
visudo
```

add the following configuration

```
%sudo ALL=(ALL) NOPASSWD: ALL
```

no need to keep typing `-K` and the sudo password, just using keys

I added a [jails] section to my hosts with the jail ip like this

```
[jails]
172.16.28.10

[jails:vars]
ansible_python_interpreter=/usr/local/bin/python3.7
```

Now I can become sudo and not have to enter in the password

```
ansible jails -m package -a "name=git-lite state=present" -b
```
