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
- Next, we’ll pick the image called `FreeBSD-12.1-RELEASE-amd64-bootonly.iso` from the list.
  - Because it’s the latest RELEASE version of FreeBSD
  - And is quite small.

I highly recommend you also take a look at the `CHECKSUM.SHA512-FreeBSD-12.1-RELEASE-amd64` file and do your own SHA512 checksum verification after you have downloaded the file to see if they match. If so, you know that your download worked properly. Once the installer image has been downloaded, it is ready to be used to boot up the virtual machine.

In VirtualBox, click the `New` button to start the wizard that will walk you through creating a virtual machine. The important options to keep in mind are the following:

- Type of OS we'll choose `FreeBSD 64 bit`,
- And the amount of RAM to dedicate to the virtual machine. Use some amount greater than 512MB and less than any number that puts your virtualbox wizard “slider” into the red. Keep your “slider” in the green, and you should be fine giving the machine a decent amount of memory to work with.
- Accept the defaults for the other settings.

Once the wizard completes, you can start up the virtual machine. Another wizard will appear asking you to point VirtualBox to the installer image for the new virtual machine. If you’d like to avoid this second wizard, simply edit the virtual machine settings before first boot:

- Clicking on the `Storage` link,
- Then the `Empty Disc` section,
- And then you can mount the virtual image on that screen.

All of these steps in VirtualBox equate to assembling the hardware and inserting the installer CD. Pressing `Start` in VirtualBox is like pressing the `Power` button to boot up a real machine. On first boot of the install CD you are welcomed to FreeBSD and asked if you would like to begin an installation. Select `Install` by pressing `Enter/Return` on the keyboard. At this point, you will have noticed VirtualBox trying to explain it is capturing your mouse and keyboard to be used inside the virtual machine. Go ahead and dismiss these messages. To use the mouse and keyboard outside of the virtual machine again, you need to press the host key. VirtualBox displays the current host key in the bottom right of the window. This install says `Right Ctrl` which means you need to press the right control button on the keyboard first to get back control over the mouse and keyboard from the virtual machine. Continue through the installer with the following in mind: for this install, we’ll continue with the default US keyboard layout, name the computer `getting-started-with-freebsd` and select the default settings on the `Distribution Select` screen by just pressing `ok` For the `Network Configuration` section, we went with the `em0` interface on the virtual machine and the `re0` interface on the real hardware. Yes, configure IPv4. Yes, use DHCP. Yes, use IPv6. Yes, try SLAAC. The resolver configuration should be populated with at least one DNS value. Use the “Tab” key on the keyboard to move to select `ok` to continue. For the `Mirror Configuration` we used `Main Site`. Next, we need to decide how to partition the disc. On the `Partitioning` screen, there are options for Auto (ZFS) and Auto (UFS). Select Auto (ZFS), choose stripe as the ZFS pool type and select the disc to use for the pool with the space-bar, name the pool, and proceed with installation. Finally, agree to install FreeBSD by selecting `Yes`.

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

Change to regular user by holding down “control” and pressing “d” on the keyboard which will log out the current user. Log in again, this time as the regular user account that was created. Next type the following commands.

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

Go back to the `Desktop Settings` window and select `Window Manager`. In the `Window Theme` drop-down menu, select `Twice`. Click on `Save`. Close the `Window Manager Settings` window. Go back to the `Desktop Settings` window and select `Applications`. Set the `E-mail Client` to Firefox and `Virtual Terminal` to Sakura. Close all the settings windows.

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
freebsd-update fetch install
# Page Down & q should get you through the prompts. If the screen shows END
# press q, use Page Down for the other screens.
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
pkg install -y git
mkdir -p /usr/local/src
cd /usr/local/src
git clone https://github.com/bsdci/ioc.git
cd ioc
make install
```

the following command assumes your zpool is named zroot adjust as necessary.

```tcsh
sysrc ioc_dataset_default=zroot/iocage
ioc list
```

We should now see an empty table as the output of ioc list, we’ll do some additional housekeeping below

```tcsh
mount -t fdescfs null /dev/fd
vi /etc/fstab
```

Add the following line to the file and exit when finished. `i` for insert mode, ESC then `ZZ` to save and quit the file. Press TAB between each of the fields for the fstab file.

```tcsh
fdescfs /dev/fd fdescfs rw 0 0
```

Download a Release branch of FreeBSD first

```tcsh
ioc fetch
```

We used [Enter] to fetch the default release iocage wants to provide. Verify the download with the following command

```tcsh
ioc list --release
```

View the help documentation

```tcsh
ioc --help
```

Any subcommands can also have the --help flag appended

```tcsh
ioc create --help
```

Create a base jail

```tcsh
ioc create jail-one
```

List current jails

```tcsh
ioc list
```

Do a filtered list of the jails based on what they are

```tcsh
ioc list release=12+
```

Setup networking on jail-one

```tcsh
ioc set vnet=off ip4_addr="em0|10.0.2.16/24” jail-one
```

List jails again to see the changes to the output

```tcsh
ioc list
```

Startup jail-one and jump into the console

```tcsh
ioc console -s jail-one
```

The -s flag will start the jail if it isn't already started. To manually start a jail use this

```tcsh
ioc start jail-one
```

Verify networking is working

```tcsh
pkg
```

Say yes to the pkg bootstrap prompt.
Exit the jail console with `ctrl + d`.
Another feature to consider is “One-Shot Jails”.
Turn off the jail first

```tcsh
ioc stop jail-one
```

try issuing the following command

```tcsh
ioc exec -f jail-one ifconfig
```

The jail should start up, run the command, display the output and then stop the jail.
To delete a jail

```tcsh
ioc destroy jail-one
```

# Poudriere

The following commands will work on the virtual machine we’ve been using sofar but it will take a long time to compile all the packages.
We’re going to use the cloned virtual machine we created earlier to explore Poudriere. Start up the cloned VM.

Commands to execute:

```tcsh
pkg install -y poudriere vim-console
mkdir /usr/ports/distfiles
vim /usr/local/etc/poudriere.conf
```

`poudriere.conf` content to modify

```
ZPOOL=zroot
FREEBSD_HOST=https://download.freebsd.org
```

Continue executing:

```tcsh
poudriere jail -c -j amd64-12-0 -v 12.0-RELEASE
poudriere jail -l
poudriere ports -cp head
poudriere ports -l
```

get together a list of packages to build. I ran `pkg query -e '%a=0' %o` on my laptop and a large list appeared. pkg query on my VM was much shorter. For this tutorial we will just build a shorter list of packages, but for reference here’s the command to export the current packages installed on the system to a file called pkglist:

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
vim /usr/local/etc/poudriere.d/amd64-12-0-make.conf
```

```
DEFAULT_VERSIONS += ssl=libressl
```

To customize a package one can use the normal package configuration screens, which will appear when issuing the following command

```tcsh
poudriere options -j amd64-12-0 -p head -f pkglist
```

For this tutorial we’ll just actually build the packages with the default options to get the hang of Poudriere by issuing the following

```tcsh
poudriere bulk -j amd64-12-0 -p head -f pkglist
cd /usr/local/poudriere/data/logs/bulk/amd64-12-0-head/latest
```

this directory contains logs and even a website at `/usr/local/poudriere/data` open the website to check status or press ctrl + t during the building to check status as well the packages that were built are available at

```
/usr/local/poudriere/data/packages/amd64-12-0-head
```

Create a pkg repository

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
vim /usr/local/etc/pkg/repos/amd64-12-0.conf
```

Add the following configuration

```
amd64-12-0: {
    url: “file:///usr/local/poudriere/data/packages/amd64-12-0-head”,
    enabled: yes,
}
```

To reinstall all packages using the new repo

```tcsh
pkg upgrade -fy
```

## Updating Poudriere

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
poudriere bulk -j amd64-12-0 -p head -f pkglist
```
