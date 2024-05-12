# Custom Ubuntu ISO Install Process

## Introduction
The document "Installing-Ubuntu.md" is a guide on how to install Ubuntu 24.04 LTS using a custom ISO file. Here's a brief overview of each section:

Prerequisites: This section should list any prerequisites or requirements for the installation process, such as hardware specifications or software dependencies.

Step 1: Downloading the Ubuntu ISO: This section provides detailed instructions on how to download the Ubuntu 24.04 LTS image from the official Ubuntu website. It also explains how to verify the integrity of the downloaded ISO file.

Step 2: Creating a Bootable USB Drive: This section guides the user on how to use the downloaded ISO file to create a bootable USB drive. It also explains how to attach the virtualized CDROM ISO to the server and how to reboot the server remotely.

## Prerequisites
Access to the server via IPMI


## Step 1: Downloading the Ubuntu ISO
To download the Ubuntu 24.04 LTS image from the official Ubuntu website, you can follow these steps:

Open a web browser and go to the Ubuntu download page: https://ubuntu.com/download/server.

On the download page, you will see different versions of Ubuntu available for download. Look for the version labeled "Ubuntu 20.04 LTS" and click on the "Download" button next to it.

Once you click the "Download" button, you will be redirected to a new page where you can choose the download method. There are two options available: "Download" and "Torrent".

If you choose the "Download" option, the ISO file will be downloaded directly to your computer.
If you choose the "Torrent" option, you will need a BitTorrent client to download the ISO file. This method can be faster and more reliable, especially for larger files.
After selecting your preferred download method, the ISO file will start downloading. The download progress will be displayed in your browser or in your BitTorrent client, depending on the method you chose.

Once the download is complete, you will have the Ubuntu 20.04 LTS ISO file saved on your computer. This file can be used to create a bootable USB drive or to install Ubuntu on a virtual machine.

Remember to verify the integrity of the downloaded ISO file by checking its checksum against the one provided on the Ubuntu website. This ensures that the file was not corrupted during the download process.


![This image from Ubuntu shows the lifecycle for various versions](ubuntu-image-lifecycle.png)

## Step 2: Creating a Bootable USB Drive
Select ISO image, then click open image and select the ISO file for ubuntu that was previously downloaded to your computer.

Then click plug in, this will make the ISO appear to the server as a bootable CDROM that has been attatched over the network.

![Image shows how to attatch the virtualised CDROM ISO to the server](attatching-ubuntuiso-over-network.png)

After attatching the CDROM the server needs to be rebooted to be able to see the bootable CDROM, this can be done by physically turning the server off and on, or via the IPMI like so:

![How to remotely reboot the server](remotely-reboot-server.png)

Here the ISO has been detected and try or install ubuntu server can be selected:

![Image shows boot when the virtual CDROM ISO is detected](selecting-tryinstall-ubuntu-boot.png)

Select the language of choice for ubuntu:

![First option, select language](first-step-ubuntuinstall.png)

Select the keyboard language based on your keyboard, for most if not all english keyboards, the default will be best:

![Second option, select keyboard language](second-step-selecting-kb-lang.png)

Select the regular Ubuntu Server, we want this version as it comes preinstalled with useful basic utilities. minimized is only suitable if running on an extremely low power system such as a raspberry pi zero:

![Third option, select install version](third-step-ubuntuinstall.png)

Here as I only had a single port available on my network switch I only plugged in the ethernet RJ45 into the IPMI port to access the IPMI from my personal computer, here I've selected continue without network as the network will be setup automatically when plugged into one of the four ports on the server, do note that this is assuming the network the server will be connecting to has DHCP to assign a local IP address to the server, otherwise a manual static local IP address will need to be assigned, this however can be done later after ubuntu is installed:

![Fourth step, ubuntu install](Fourth-step-ubuntuinstall.png)

We have no proxy address, continue by clicking done:

![Fith step, ubuntu install](Fith-step-ubuntuinstall.png)

We will be using the default as our mirror as we do not have or need a mirror (a mirror location can be often on site to reduce network usage so that ubuntu packages are downloaded locally once and then cached whenever a server requires it):

![Sixth step, ubuntu install](sixth-step-ubuntuinstall.png)

We will use the entire disk for the LVM partition for our ubuntu install:

![Seventh step, ubuntu install](seventh-step-ubuntuinstall.png)

Here only 100GiB will be allocated to the disk in the LVM partition for Ubuntu, we will increase this to the full disk after Ubuntu is installed:

![Eighth step, ubuntu install](eighth-step-ubuntuinstall.png)

We will use [Nayuki Project](https://www.nayuki.io/page/random-password-generator-javascript), this will use local javascript on the computer to generate a secure password (this page can also be downloaded to prove it can run without internet showcasing it doesn't make any calls to a server with the credentials), I have chosen a good middle ground for password length and security, ensuring that it's easy to type into the IPMI yet secure at an estimated 700 billion years to crack the password:

![Neinth step, secure password 700 billion years to crack](nineth-step-ubuntuinstall.png)

Here we are creating the ubuntu user account, I have selected indigicloud as the username and hostname such that if a network admin sees the device connected to their network then they will be shown the hostname making it easier and quicker to identify the server, the password entered is the one generated earlier using Nayuki Project, ensure to type the password slowly character by charecter because IPMI is subpar for keyboard input latency accuracy:

![Neinth step ubuntu install user setup](tenth-step-ubuntuinstall.png)

We do not need Ubuntu Pro which is a subscription based service and unecesarry for 99.9% of user tasks:

![Elenth step ubuntu install](elenth-step-ubuntuinstall.png)

Select Install OpenSSH server, this is vital so that after setup we can communicate with the server via SSH:
This can be installed later, but is easier to do so on setup.

![Twelth step ubuntu install, select openssh server](twelth-step-ubuntuinstall.png)

Now the system will install ubuntu, reboot after by selecting reboot.

Plug out the virtual CDROM ubuntu ISO as it is no longer needed:

![Thirteenth step ubuntu install, unplug the virtual cd rom ubuntu ISO](thirteenth-step-ubuntuinstall.png)

if the system hangs after saying CDROM can't unmount then try entering a random letter and then enter.

Ubuntu has been installed!


## Step 3: Connecting via SSH

Now that ubuntu is installed, I unplugged the ethernet cable from the IPMI port and then proceeded to plug it into one of the four WAN ports, after doing so my router automatically assigned it an IP address in my local subnet. through this I found the IP address, set it as a static DHCP IP

![router device list](router-devices-list.png)

Here is me setting the local IP to a static DHCP reservation ensuring the local IP in the subnet doesn't change on system reboots or reconnections. Noting that this practice is only important if the servers IP is dynamically set via the DHCP server on the router, and if control of the router can't be accessed then its likely to be a matter for the network admin to set.

![router static dhcp](static-local-ip.png)

And here is me connecting via SSH:

![connecting via ssh](connecting-ssh.png)

## Step 4: Extending the LVM where the ubuntu install is to use all allocated space:


Find the LV Path variable:

```sudo lvdisplay```

Extend the LV to max size:

```sudo lvextend -l +100%FREE /dev/vgname/lvname```

resize the file system to make use of increased space:

```sudo resize2fs /dev/vgname/lvname```

Use `df -h` to see the volume size:
Here we can see that the volume mounted on / is now of size 456GiB and has 427GiB free which makes sense as this is a 500GB NVME SSD.

```
indigicloud@indigicloud:~$ df -h
Filesystem                         Size  Used Avail Use% Mounted on
tmpfs                              3.2G  1.5M  3.2G   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv  456G   11G  427G   3% /
tmpfs                               16G     0   16G   0% /dev/shm
tmpfs                              5.0M     0  5.0M   0% /run/lock
/dev/nvme0n1p2                     2.0G   95M  1.7G   6% /boot
tmpfs                              3.2G   12K  3.2G   1% /run/user/1000
indigicloud@indigicloud:~$ 
```


