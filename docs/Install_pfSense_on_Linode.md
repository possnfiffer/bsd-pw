# Install pfSense on Linode
Create your Linode in your preferred data center using the old interface available at https://manager.linode.com/ . Not sure how to do this on the new Interface. For the purposes of this tutorial, we recommend turning Lassie off to prevent the watchdog from attempting to restart your Linode without your input. You can disable Lassie in the Settings tab of the Linode Manager under Shutdown Watchdog.

Create two disk images; both should be in the RAW format.

    The first should be a 1024 MB image labeled Installer.
    The second should use the Linode’s remaining space. Label it pfSense.

Create two configuration profiles with the following settings. In each profile, you will need to disable all of the options under Filesystem/Boot Helpers.

Installer profile

    Label: Installer
    Kernel: Direct Disk
    /dev/sda: pfSense disk image.
    /dev/sdb: Installer disk image.
    root / boot device: Standard /dev/sdb

Boot profile

    Label: pfSense
    Kernel: Direct Disk
    /dev/sda: pfSense disk image.
    root / boot device: Standard /dev/sda

Boot into Rescue Mode with the installer disk mounted to /dev/sda and access your Linode using Lish via SSH from the Remote Access tab of the Linode Manager.

```
curl -O -k https://nyifiles.pfsense.org/mirror/downloads/pfSense-CE-memstick-2.4.4-RELEASE-amd64.img.gz
gunzip -c pfSense-CE-memstick-2.4.4-RELEASE-amd64.img.gz | dd of=/dev/sda bs=512k
```

When the command finishes, reboot into your Installer profile.

Go to the Remote Access tab in the Linode Manager. Access your Linode using Glish to start the installation. Note that Glish must be used to complete the installation of pfSense

## pfSense Installer

<Accept>

Install

Continue

ZFS

Stripe of da0

Proceed with installation

Yes in final modifications

```
vi /boot/loader.conf
```

add the configuration

```
boot_multicons="YES"
boot_serial="YES"
comconsole_speed="115200"
console="comconsole,vidconsole"
```

Exit Glish, return to the Linode Manager and reboot into the pfSense profile.

Open lish

answer n to VLANs setup

vtnet0 for WAN

enter for rest till you see Bootup complete

close list

open Glish

type 13 to update from console say y to update



work in progress
