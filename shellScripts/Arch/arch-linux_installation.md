# arch-linux_installation

  * Author : Spyridakis Christos
  * Created Date : 14/7/2019
  * Last Updated : 18/2/2020
  * Email : spyridakischristos@gmail.com


##  Description: 
Both personal instructions, based on arch linux wiki and some forums, and commands needed to install and use arch linux on my system. This file is free and open source ; please make sure to read the documentation of each application before install or use it. I am not responsible for any damage.     

___
___


```
 ___           _        _ _       _   _             
|_ _|_ __  ___| |_ __ _| | | __ _| |_(_) ___  _ __  
 | || '_ \/ __| __/ _` | | |/ _` | __| |/ _ \| '_ \ 
 | || | | \__ \ || (_| | | | (_| | |_| | (_) | | | |
|___|_| |_|___/\__\__,_|_|_|\__,_|\__|_|\___/|_| |_|

```
This guide includes my personal notes for arch linux installation, please visit arch linux wiki for a complete installation guide: [arch wiki](https://www.archlinux.org/)

### Instructions
0. If you want to use arch as dual boot with windows disable fast boot, install windows if you have a blank hard drive and log in windows. 

    - Then Press "Windows key" -> Goto "Control Panel" -> Goto "Power Options" -> Goto "Choose what the power buttons do" -> Press "Change settings that are currently unavailable" -> Disable "Turn on fast startup" -> Save changes

    - Disable also secure boot from bios/uefi.

1. Download iso and signature files from here: [https://www.archlinux.org/download/](https://www.archlinux.org/download/)


2. Verify signature (NOTE: change VERSION with your version)
   ```
   gpg --keyserver-options auto-key-retrieve --verify archlinux-VERSION-x86_64.iso.sig
   ```

   * It may appears this kind of output:
    ```
    gpg: assuming signed data in `./archlinux-2019.07.01-x86_64.iso'
    gpg: Signature made Mon 01 Jul 2019 06:07:38 pm EEST using RSA key ID 9741E8AC
    gpg: using PGP trust model
    gpg: Good signature from "Pierre Schmitz <pierre@archlinux.de>"
    gpg: WARNING: This key is not certified with a trusted signature!
    gpg:          There is no indication that the signature belongs to the owner.
    Primary key fingerprint: 4AA4 767B BC9C 4B1D 18AE  28B7 7F2D 434B 9741 E8AC
    gpg: binary signature, digest algorithm SHA256
    ```
    Don't worry that it is a good but not certified signature! It's ok!
   
3. Create a live media, e.g. bootable USB using commands of this section or find out an other way here:  
[https://wiki.archlinux.org/index.php/USB_flash_installation_media](https://wiki.archlinux.org/index.php/USB_flash_installation_media)

    - Find out USB name and umount it (replace X of sdX with driver's letter and N with partition number)
        ```
        lsblk
        umount /dev/sdXN
        ```

    - Create the bootable USB, change X of sdX with the desired driver's letter
        ```
        sudo dd bs=4M if=path/to/archlinux.iso of=/dev/sdX status=progress oflag=sync
        ```

    - Afterwards (when you would like to use the USB again as a media drive) run the command below and then repartition and reformate the drive. Change X of sdX with driver's letter.
        ```
        sudo wipefs --all /dev/sdX
        ```

4. Connecto to internet.
 
 * Just by using an  ethernet cable or use `wifi-menu` to connect to a visible wifi access point. 
 * For a hidden SSID.
   
    * Just create a config file on */etc/netctl/*, with your profile's name e.g. */etc/netctl/wlan0-SSID_NAME* that contains:

        ```
        Description='Custom generated profile'
        Interface=YOUR_INTERFACE (e.g. wlan0)
        Connection=wireless
        Security=wpa
        ESSID=YOUR_SSID_NAME
        IP=dhcp
        Key=YOUR_PASSWORD
        Hidden=yes
        ```

   * Then run: `netctl start PROFILE_NAME`
 
 * Check if there is an internet connection:
    ```
    ip addr show    # short version: ip a
    ```

5.  Verify EFI support.
    
    In my case, i want to install arch in dual boot alongside windows in uefi mode.
    In case that efi directory is not found you are in legacy mode.

    ```
    ls /sys/firmware/efi/efivars
    ```
   
6. Change default root password (i usually want to continue installation using ssh from an other pc)
    
    ```
    sudo passwd root
    ```
   
7. Check if ssh is enabled or enable it

    ```
    systemctl status sshd
    systemctl start sshd        # Only if it is disabled
    ```

    Note: This step is optional, you have to do it only if you want to run the installation through ssh
    
    Then connect to ssh server

8. Update the system clock
   
    ```
    timedatectl set-ntp true
    ```
    
    Note: Check it by executing
    
    ```
    timedatectl status
    ```

1. 

1.  

1.  

8. 

9.  

10. 

11. 

12. 
___
___

```
 ____                                  
|  _ \ __ _  ___ _ __ ___   __ _ _ __  
| |_) / _` |/ __| '_ ` _ \ / _` | '_ \ 
|  __/ (_| | (__| | | | | | (_| | | | |
|_|   \__,_|\___|_| |_| |_|\__,_|_| |_|
```

### Cheatsheet
Command             | Description
--------------------|------------
pacman -Sy          | Just syncronize package databases (does not update programs)                                                      
pacman -Su          | Actually update programs                                                                                          
pacman -Syu         | Syncronize package databases and update programs (same as update and upgrade system on Debian based distros)      
pacman -Syy         | Double check remotes                                                                                              
pacman -Sc          | Remove packages from cache (remove old versions of packages, in simple words clears not needed space from root)   
pacman -Ss ^pro     | Search every program that its title or description starts with pro (regex)                                        
pacman -R program   | Remove a program                                                                                                  
pacman -Rs program  | Remove a program with its dependencies                                                                            
pacman -Rns program | Remove a program with its dependencies and its system config files                                                
pacman -Q           | List all installed programs                                                                                       
pacman -Qe          | Programs that user has explicity installed                                                                        
pacman -Qeq         | Only provides program name without extra info e.g. version                                                            
pacman -Qn          | All programs installed from main repositories                                                                     
pacman -Qm          | All programs installed from AUR                                                                                   
pacman -Qdt         | Uneeded dependencies (orphans)                                                                                    
pacman -Qs program  | Seach a program on local repository                                                                               


### Extra
*  Pacman configuration file: /etc/pacman.conf. You may want to uncomment in Mics options these: Color, VerbosePackages, CheckSpace

* Update /etc/pacman.d/mirrorlist. Just move on top closest to you mirrors