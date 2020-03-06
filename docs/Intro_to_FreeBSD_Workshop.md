# SCaLE18x Intro to FreeBSD

## Requirements

- VirtualBox (5+ is the version we used but any version should be fine. This program works on most computers, be sure to enable VT-x in your computers BIOS)
- Internet access

## Workshop

### Morning

To begin, we can simply:

- Visit [FreeBSD.org](https://FreeBSD.org) on a working computer
- Look for the big `Download FreeBSD` button near the awesome beastie logo.
- Once on that page, you will need to select the proper image from the list of `Installer Images`. We'll choose `amd64`.
- Next, we’ll pick the image called `FreeBSD-12.1-RELEASE-amd64-disc1.iso` from the list.
  - Because it’s the latest RELEASE version of FreeBSD

I highly recommend you also take a look at the `CHECKSUM.SHA512-FreeBSD-12.1-RELEASE-amd64` file and do your own SHA512 checksum verification after you have downloaded the file to see if they match. If so, you know that your download worked properly. Once the installer image has been downloaded, it is ready to be used to boot up the virtual machine.

In VirtualBox, click the `New` button to start the wizard that will walk you through creating a virtual machine. The important options to keep in mind are the following:

- Type of OS we'll choose `FreeBSD 64 bit`,
- And the amount of RAM to dedicate to the virtual machine. Use some amount greater than 512MB and less than any number that puts your virtualbox wizard “slider” into the red. Keep your “slider” in the green, and you should be fine giving the machine a decent amount of memory to work with.
- Accept the defaults for the other settings.

Once the wizard completes, you can start up the virtual machine. Another wizard will appear asking you to point VirtualBox to the installer image for the new virtual machine. If you’d like to avoid this second wizard, simply edit the virtual machine settings before first boot:

- Clicking on the `Storage` link,
- Then the `Empty Disc` section,
- And then you can mount the virtual image on that screen.

All of these steps in VirtualBox equate to assembling the hardware and inserting the installer CD. Pressing `Start` in VirtualBox is like pressing the `Power` button to boot up a real machine. On first boot of the install CD you are welcomed to FreeBSD and asked if you would like to begin an installation.

Select `Install` by pressing `Enter/Return` on the keyboard. At this point, you will have noticed VirtualBox trying to explain it is capturing your mouse and keyboard to be used inside the virtual machine. Go ahead and dismiss these messages. To use the mouse and keyboard outside of the virtual machine again, you need to press the host key. VirtualBox displays the current host key in the bottom right of the window. This install says `Right Ctrl` which means you need to press the right control button on the keyboard first to get back control over the mouse and keyboard from the virtual machine.

Continue through the installer with the following in mind:

for this install, we’ll continue with the default US keyboard layout, name the computer `getting-started-with-freebsd` and select the default settings on the `Distribution Select` screen by just pressing `ok` For the `Network Configuration` section, we went with the `em0` interface on the virtual machine as we know that VirtualBox uses the intel network driver which has the `em0` designation. On some machines you will find the `re0` interface which is the Realtek network driver. 

Yes, configure IPv4. Yes, use DHCP. Yes, use IPv6. Yes, try SLAAC. The resolver configuration should be populated with at least one DNS value. Use the “Tab” key on the keyboard to move to select `ok` to continue. For the `Mirror Configuration` we used `Main Site`. Next, we need to decide how to partition the disc. On the `Partitioning` screen, there are options for Auto (ZFS) and Auto (UFS). Select Auto (ZFS), choose stripe as the ZFS pool type and select the disc to use for the pool with the space-bar, name the pool, and proceed with installation. Finally, agree to install FreeBSD by selecting `Yes`.

#### User Accounts

Set a password for the root account on the system. Don’t fret when there are no `***` appearing while typing in your root password. Rest assured, the keystrokes are being recorded; they’re just not being shown on the Screen. For the `Time Zone` section we went with `America – North and South, United States of America`, `Mountain (most areas)`, `Skip` on both `Time & Date` screens. For the `System Configuration` section, we unselected `sshd`, selected `powerd` and chose `ok`. On the next screen, we selected `9 secure_console` to put the root password prompt on any attempt to enter Single User Mode at the system console. Say “yes” to the prompt about adding a new user. Use an all lowercase username. Enter the users `Full name`. Add the user account to the groups `wheel`, `operator`, `video` by responding to the question `Login group is .. Invite .. into other groups? []:` with `wheel operator video` then press `Enter`. Users in the `wheel` group can run “privileged” commands. The `operator` group allows users to do things like shutdown and restart the computer without needing to invoke the special privileges from the wheel group. It's a good idea to add users to the `video` group that is planning on using FreeBSD as a desktop. We chose `tcsh` for our shell and used defaults for the other fields while finally providing an account password. If all looks ok, proceed without creating any more user accounts.

For the `Final Configuration` section, select `Handbook`. We went with the default of `en` and chose `ok`. Once back on the configuration screen, select `Exit` to finish and `yes` to proceed with doing manual configuration. The only manual configuration we need to do is to shut down the machine so we can take out the CD. On the virtual machine, the power needs to be off to not get an error when removing the CD, so we’ll issue the shutdown command below to turn off the computer. Type either `init 0` or `shutdown -p now` to shut down. To take a CD out of a virtual machine in VirtualBox, click on the name of the virtual machine, click on `Settings`, click on `Storage`, and click on the tiny CD icon. Notice another tiny CD icon with a tiny down arrow below it next to the `Optical Drive` section. Use this second CD icon to `Remove Disk from Virtual Drive`.

#### Cloning a VirtualBox VM

Use the `Snapshots` menu in VirtualBox to `Clone` the VM. Check the box `Reinitialize the MAC address of all network cards`. We could choose either a `Full clone` or a `Linked clone`. We’ll use the `Full clone` option. Later on we’ll use this cloned VM.

### After a break

Boot up the first VM, use the `Start` button to boot the machine and log in as the root user.

#### Package Installation / Text Configuration

Type the following commands on the virtual machine:

```tcsh
pkg install -y xorg sudo lumina sakura virtualbox-ose-additions firefox vim-console
sysrc vboxguest_enable=YES
sysrc vboxservice_enable=YES
visudo (this command launches the vi text editor).
```

Type the following to edit the one line of text and get out of the editor:

```
/wheel
```

Type enter or hit return and then type

```
j0xxZZ (once you hit the first search term, j goes down, 0 goes to the beginning of the line, xx deletes the comment, ZZ saves and quits vi)
```

```tcsh
sysrc dbus_enable=YES
dbus-uuidgen > /etc/machine-id
service dbus start
```

Change to regular user by holding down “control” and pressing “d” on the keyboard which will log out the current user. You can also just type "logout" to do the same thing. Log in again, this time as the regular user account that was created. Next type the following commands.

```tcsh
vim .xinitrc
```

This time we use the vim editor, VI iMproved, and to begin typing you need to be in “insert mode” and must press `i` to enter insert mode and begin typing in text. Type in the following one-line configuration:

```
exec start-lumina-desktop
```

Exit vim by pressing “Esc” on the keyboard, then type `ZZ` or `:wq` followed by `Enter/Return`. At this point the virtual machine desktop can be started with the following command:

```tcsh
startx
```

##### Known issues

- If you notice that your mouse is kinda slow, shutdown your machine and then do the following:
  - Open your VM `Settings` -> `Display` tab
  - Confirm `VBoxVGA` is selected
  - Click `OK` and start your machine again.

#### Desktop Configuration

Right click on the desktop > `Preferences` > `All Desktop Settings` Under `Appearance` click on `Theme`, then select `Icons` from the sidebar, then select `Material Design (light)`, and click on `Apply`. Close the `Theme Settings` window.

Go back to the `Desktop Settings` window and select `Window Manager`. In the `Window Theme` drop-down menu, select `Twice`. Click on `Save`. Close the `Window Manager Settings` window. Go back to the `Desktop Settings` window and select `Applications`. Here we can setup the default applications used to open specific file types. If you set the `E-mail Client` to Firefox you can use the built in `mailto` handler in Firefox to automatically open up your web based email client such as Gmail or Yahoo Mail when you click on an e-mail address link. See Firefox documentation for other supported webmail platforms and other configuration settings available. In the section called `Virtual Terminal` set the default to be Sakura. Close all the settings windows.

Right click on the desktop and select `Preferences` then `Wallpaper`, click on the `+`, and choose `solid color`. We chose red for our color. Click `ok`, then `Save`.

#### FreeBSD Handbook

Here is how to open a local copy of the handbook we installed in the Final Configuration:

- Look for Firefox in the applications menu in Lumina.
  - Right click on: `Desktop` > `Applications` > `Network` > `Firefox Web Browser`
- Open Firefox and navigate to the following URL: `file:///usr/local/share/doc/freebsd/handbook/index.html`

This is a local copy of the FreeBSD Handbook, and it will always be available as it doesn't require an active internet connection. That’s all it takes to install FreeBSD. The next recommended step is to choose a firewall and configure it. Also recommend you pick up a copy of the book “BSD Hacks” to get more familiar with the `tcsh` shell as well as to acquire several new skills.

### Back to the slides

## FreeBSD Update and package

### updates

```tcsh
sudo -i
env PAGER=cat freebsd-update fetch install
```

We're using env PAGER=cat to modify the value of the PAGER variable which is used by the freebsd-update shell script. If you open up the shell script you will see the default value of PAGER is set to `less`. You can find the location of the freebsd-update shell script by typing `which freebsd-update`. By setting the value of PAGER to `cat`, `freebsd-update` will not stop to display the list of file to be updated, instead the `cat` command will only display the list of files and won't stop to wait for you to read. If you only type `freebsd-update fetch install` you'll need to use the following to get through the prompts

Page Down & q should get you through the prompts. If the screen shows END press q, use Page Down for the other screens. You can also use q for every screen.

Now that FreeBSD itself is up to date, we should also update the packages.

```tcsh
pkg update
pkg upgrade -y
```

### Jails

#### IOCAGE

Set UTF-8 as the locale for this host

```tcsh
vim /etc/login.conf
```

Change the line with `:umask=022:` to look like the following:

```
:umask=022:\
:charset=UTF-8:\
:lang=en_US.UTF-8:
```

save and quit the editor then run the following

```tcsh
cap_mkdb /etc/login.conf
logout
```

Login again as root and type the following to verify UTF-8 locale has been set

```tcsh
locale
```

Install iocage

```tcsh
pkg install -y iocage
```

the following command assumes your zpool is named zroot adjust as necessary. Type `zpool status` to see the current name of your zpool.

```tcsh
iocage activate zroot
iocage list
```

We should now see an empty table as the output of iocage list, we’ll do some additional housekeeping below to improve performance of iocage. There are many things you can do to optimize performance of various applications. One way to learn several new tips and tricks is to read the supurb collection of FreeBSD Mastery books available at https://MWL.io (In fact, the following performance optimization trick was in the book FreeBSD Mastery: Jails)

```tcsh
mount -t fdescfs null /dev/fd
vi /etc/fstab
```

Add the following line to the file and exit when finished. `i` for insert mode, ESC then `ZZ` to save and quit the file. Press TAB between each of the fields for the fstab file rather than using spaces to separate fields.

```tcsh
fdescfs /dev/fd fdescfs rw 0 0
```

Download a Release branch of FreeBSD first

```tcsh
iocage fetch
```

We used [Enter] to fetch the default release iocage wants to provide. Verify the download with the following command

```tcsh
iocage list -r
```

View the help documentation

```tcsh
iocage --help
```

Any subcommands can also have the --help flag appended

```tcsh
iocage create --help
```

Create a base jail

```tcsh
iocage create -T -n JAILNAME ip4_addr="10.0.2.16" -r 12.1-RELEASE
```

List current jails

```tcsh
iocage list
```

Startup jail-one and jump into the console

```tcsh
iocage console JAILNAME
```

The console command will start the jail if it isn't already started. To manually start a jail use this

```tcsh
iocage start JAILNAME
```

Similarly to stop a jail issue

```tcsh
iocage stop JAILNAME
```

Verify networking is working

```tcsh
pkg
```

Say yes to the pkg bootstrap prompt.
Exit the jail console with `ctrl + d`.

To delete a jail

```tcsh
iocage destroy JAILNAME
```

# Poudriere

The following commands will work on the virtual machine we’ve been using so far but it will take a long time to compile all the packages.

We’re going to use the cloned virtual machine we created earlier to explore Poudriere.

Start up the cloned VM.

Commands to execute as the root user:

```tcsh
pkg install -y poudriere vim-console
mkdir /usr/ports/distfiles
mkdir /usr/local/poudriere
vim /usr/local/etc/poudriere.conf
```

`poudriere.conf` content to modify

```
ZPOOL=zroot
FREEBSD_HOST=https://download.freebsd.org
```

Continue executing:

```tcsh
poudriere jail -c -j amd64-12-1 -v 12.1-RELEASE
poudriere jail -l
poudriere ports -cp head
poudriere ports -l
```

get together a list of packages to build. I ran `pkg query -e '%a=0' %o` on my laptop and a large list appeared. pkg query on my VM was much shorter. To learn more about `pkg query` issue the command `pkg help query` to see help text for the query subcommand. Most commands support some form of help (-h, --help, or simply reading the man page with `man PROGRAM`) For this tutorial we will just build a shorter list of packages. The command to export the current packages installed on the system to a file called pkglist is

```tcsh
pkg query -e ‘%a=0’ %o | tee pkglist
```

```tcsh
editors/vim-console
ports-mgmt/pkg
ports-mgmt/poudriere
```

**Note**: `tee` writes output to a file and also to `stdout`. Also the following two bits of information are optional for this tutorial and are included to show you how to customize packages.

Two ways to configure custom options for packages, manually and with the normal make config screen.
FYI: Manually looks like this

```tcsh
vim /usr/local/etc/poudriere.d/amd64-12-1-make.conf
```

```
DEFAULT_VERSIONS += ssl=libressl
```

To customize a package one can use the normal package configuration screens, which will appear when issuing the following command

```tcsh
poudriere options -j amd64-12-1 -p head -f pkglist
```

For this tutorial we’ll just actually build the packages with the default options to get the hang of Poudriere by issuing the following

```tcsh
poudriere bulk -j amd64-12-1 -p head -f pkglist
cd /usr/local/poudriere
```

this directory contains logs related to Poudriere builds. There are even a few different website files generated at `/data/logs/bulk/.html/` with information about the builds. You can open the website in Firefox using the URL `file:///data/logs/bulk/.html/index.html` to check on the status of a current Poudriere build. You can also press `ctrl + t` on the command line where you issued the `poudriere bulk` command to issue a SIGINFO to Poudriere which is configured to print out the current status of the Poudriere build while the command is still processing. This trick works on many other commands as well to show you the status. For instance if you were using `scp` to download a large file and wanted to see how far along the download was SIGINFO would print out the status on the command line to show you. Another example is if you were decompressing a zip file and wanted to know the status of the extraction process.

Once Poudriere has finished, the packages that were built are available at

```
/data/packages/amd64-12-1-head
```

Create a pkg repository

```tcsh
mkdir -p /usr/local/etc/pkg/repos
```

Disable the main FreeBSD repo by creating a file to override the default settings found in the default FreeBSD repository file `/etc/pkg/FreeBSD.conf`

```tcsh
vim /usr/local/etc/pkg/repos/FreeBSD.conf
```

Type in the following configuration with enabled set to no

```
FreeBSD: {
    enabled: no
}
```

Create a new configuration file for your local Poudriere package repository similar to the FreeBSD.conf file to hold the repository configuration

```tcsh
vim /usr/local/etc/pkg/repos/amd64-12-1.conf
```

Add the following configuration

```
amd64-12-1: {
    url: “file:///data/packages/amd64-12-1-head”,
    enabled: yes,
}
```

To reinstall all packages using the new repo

```tcsh
pkg upgrade -fy
```

## Updating Poudriere

NOTE: A good Systems Administration practice is to add comments to your configs to let the future you know what the config options do and why there were put there in the first place. That way when you revisit a config file after some time, you'll have some context as to why those options were chosen.

```tcsh
vim /usr/local/etc/poudriere.conf
```

```
# by default Poudriere builds all packages in the pkglist by default, these two lines tell Poudriere to look at each package individually to see if the currently built package is already at the latest version, if so, Poudriere will skip building the package again. This way only packages that need updates are being rebuilt, speeing up the overall build time for your package repository as you issue updates going forward.

CHECK_CHANGED_OPTIONS=verbose
CHECK_CHANGED_DEPS=yes
```

```tcsh
poudriere jail -j amd64-12-1 -u
poudriere ports -p head -u
poudriere bulk -j amd64-12-1 -p head -f pkglist
```

You can now install the updated packages
```tcsh
pkg update
```

# Ansible

Ansible is a configuration management tool to allow one to create reusable scripts to perform multiple actions on groups of servers or a single server. Ansible organizes tasks into Ansible Playbooks and supports the separation of servers into multiple groups called roles. You can assign certain tasks to their respective roles. Tasks are made up of modules that allow the script to be idempotent. An example would be the package module where you can set the state of absent. If the package is on the system, Ansible will make sure the package is removed or absent. If the package isn't on the system, Ansible won't do anything and will report back to the control machine that invoked the `ansible-playbook` command that there were no changes made as the package we wanted to be absent was indeed absent from the system when Ansible checked. This control machine is usually your development machine. Ansible sends commands to the machines listed in your Ansible hosts file from the control machine using `ssh`.

# Install Ansible

```tcsh
pkg install -y py36-ansible
```

# fetch the Ansible playbook for the workshop
# extract the contents of the compressed Ansible file
# using an ssh key already added to Digital Ocean or show how to create an ssh key and add it to Digital Ocean?

```tcsh
ssh-agent tcsh
ssh-add .ssh/id_rsa
cd extracted-ansible-directory
ansible-playbook -vv playbook.yml
```
