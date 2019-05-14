#!/bin/bash
#####################################################################################################################
#
#   apps_install-1.1-debian.sh
#
#   Author : Spyridakis Christos
#   Created Date : 3/05/2017
#   Last Updated : 4/5/2019
#   Email : spyridakischristos@gmail.com
#
#
#   Description : 
#       Install some of my favorite (and in my personal point of view useful) applications in a Debian-
#       based system (Tested on Ubuntu Unity 16.04). This script is free and open source software ; please
#       make sure to read the documentation of each application before install or use it. I am not responsible  
#       for any damage  
#
#
#   Additional Comments: 
#       1) For some Applications, their description is based on official application's description 
#       2) The following functions are implemented:
#           a) __ADDREP - Use it in order to execute command "sudo add-apt-repository -y" and afterwards update system
#           b) __INST - Use it in order to execute command "sudo apt-get -y install"
#           c) __GET - Download application from official site 
#           d) __START - Creates a desktop entry on ~/.config/autostart
#       3) Uncomment or comment out applications in order to personalize script behaviour
#       4) Feel free to use it as you like
#
#
####################################################################################################################

interpreter='bash'

#-----------------------------------------------------------
#-----------------------   IMPORTANT -----------------------
#-----------------------------------------------------------
# If you need to use #!/bin/sh uncomment the following line

#interpreter='sh'

#-----------------------------------------------------------

if [ ${interpreter} = "bash" ] ; then
    declare -a comletedApps
    declare -a failedApps
fi

# Color changing variables
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

helpMenu(){
    echo "Usage: $0 [Option]... [Option]... "
    echo "Usage: $0 -F"
    echo "Usage: $0 -L [Option]... [Option]... "
    echo "Install some of my favorite (and from my point of view, useful) applications on a Debian-based system"
    echo 
    echo "Options:"
    echo "  -c, --content             video and photo editing programs"
    echo "  -d, --develop             IDEs and editors"
    echo "  -e, --engineering         tools for engineers"
    echo "  -f, --files               file managers, editors etc..."
    echo "  -g, --games               linux games"
    echo "  -h, --help                show this help page"
    echo "  -m, --media               media players (music, video, etc...)"
    echo "  -n, --net                 browsers"
    echo "  -o, --onboot              create desktop entries on ~/.config/autostart"
    echo "  -p, --pentest             some penetration testing tools"
    echo "  -l, --peripheral          peripheral device management services"
    echo "  -s, --system              system tools"
    echo "  -w, --web                 web related software"
    echo "  -F, --Full                complete installation"
    echo "  -L, --Light               typical installation"
}

# Install apps
__INST(){
    for app in "$@" 
    do 
        echo "Try to install: ${yellow} ${app} ${reset}" 
        if [ ${interpreter} = "bash" ] ; then
            sudo apt-get -y install ${app} && comletedApps+=("${app}") || failedApps+=("${app}")
        else 
            sudo apt-get -y install ${app} && echo "${app} : ${green}Installation COMPLETED${reset}" || echo "${app} : ${red}Installation FAILED${reset}"
        fi
        echo
    done
}

# Add repository
__ADDREP(){
    sudo add-apt-repository -y ${1}
    sudo apt-get -y update --fix-missing
}

# Update and upgrade system
__UPDG(){
    sudo apt-get -y update --fix-missing
    sudo apt-get -y upgrade 
    sudo apt-get -y autoclean
    sudo apt-get -y autoremove
}

# Update system
__UPD(){
    sudo apt-get -y update --fix-missing
}

# Creates a desktop entry on ~/.config/autostart
__START(){
    entry="[Desktop Entry]\n"
    entry+="Type=Application\n"
    nameT=""
    execT=""
    commentT=""

    while :
    do
        case "$1" in
            -n   )  nameT=${2}                    ; shift ; shift;;
            -e   )  execT=${2}                    ; shift ; shift;;
            -c   )  commentT=${2}                 ; shift ; shift;;
            -i   )  entry+="Icon=${2}\n"          ; shift ; shift;;
            -ndf )  entry+="NoDisplay=false\n"    ; shift;;
            -ndt )  entry+="NoDisplay=true\n"     ; shift;;
            -hf  )  entry+="Hidden=false\n"       ; shift;;
            -ht  )  entry+="Hidden=true\n"        ; shift;;
            -tf  )  entry+="Terminal=false\n"     ; shift;;
            -tt  )  entry+="Terminal=true\n"      ; shift;;
            -sf  )  entry+="StartupNotify=false\n"; shift;;
            -st  )  entry+="StartupNotify=true\n" ; shift;;
            -gf  )  entry+="X-GNOME-Autostart-enabled=false\n" ; shift;;
            -gt  )  entry+="X-GNOME-Autostart-enabled=true\n"  ; shift;;

            -*)
                echo "Unknown option: $1 on function __START" >&2
                exit 1 
                ;;
            *) 
                break
        esac
    done

    entry+="Name=${nameT}\n"
    entry+="Exec=${execT}\n"
    entry+="Comment=${commentT}\n"

    echo -e ${entry} > ~/.config/autostart/${nameT}.desktop
}

__GET(){
    wget ${1} -P ~/Downloads
}

# Print some interesting informations at the end
__INFO(){

    if [ ${interpreter} = "bash" ] ; then 
        echo
        echo "${yellow}--------------------------------"
        echo "         SCRIPT RESULTS:"
        echo "--------------------------------${reset}"
    
        if [ ${#comletedApps[*]} -ne 0 ] ; then
            echo 
            echo " ${green}Successfully Installed/Updated Applications:${reset}"
            
            for app in ${comletedApps[@]}
            do
                echo "- ${app}" 
            done
        fi
        
        if [ ${#failedApps[*]} -ne 0 ]; then
            echo
            echo " ${red}There is a problem with the installation" 
            echo " of the following applications:${reset}"
            
            for app in ${failedApps[@]}
            do
                echo "- ${app}" 
            done
        fi 
        echo
    fi

    echo "${green}Installation Completed!${reset}"
}

contentCreate(){
    __INST blender                                    #3D modeling tool
    #__INST kdenlive                                  #Video Editing Software
    #__INST krita                                     #Photo Editing Software
    #__INST kazam                                     #Screencasting program

    # Gimp - Photo Editing Software
    __ADDREP ppa:otto-kesselgulasch/gimp
    __INST gimp

    #TODO : Lightworks
}

codeDevelopment(){
    __INST arduino arduino-core                       #Arduino IDE
    __INST git                                        #Version control system
    __INST vim                                        #Vim terminal text editor
    #__INST emacs                                     #Emacs terminal text editor
    #__INST eclipse                                   #IDE
    #__INST netbeans                                  #IDE

    #TODO Android studio
    #TODO VS_CODE
}

engineering(){
    __INST virtualbox                                  #Virtual Machine
    __INST phpmyadmin                                  #Administration tool for MySQL and MariaDB
    #__INST logisim                                    #logic circuits design
    #__INST eagle                                      #Schematics and pcb design tool
    #__INST fritzing                                   #Schematics and pcb design tool
    #__INST guake                                      #One key(drop-down) terminal
    #__INST qreator                                    #Create qr codes GUI
    #__INST qrencode                                   #Create qr codes Terminal
    #__INST kexi                                       #All in one Sql gui

    # Octave (Matlab linux alternative)
    __ADDREP ppa:octave/stable
    __INST octave

    # Kicad 
    __ADDREP ppa:js-reynaud/kicad-5.1
    __INST kicad

    # Docker 
    # TODO : Add commands
    
    # Postgresql Server and Client
    __INST pgadmin3 postgresql postgresql-contrib           
    # Postgresql Server configuration steps:
        #1) sudo -u postgres psql postgres  #Connect to db postgres via psql as user postgres
        #2) \password postgres              #Change pass for postgres user
}

files(){
    __INST system-config-samba samba                   #Share files on LAN (In order to setup user use: sudo smbpasswd -a username)
    __INST pdfshuffler                                 #Pdf editor (Merge, remove pages, etc)
    __INST meld                                        #Diff GUI programm (For both Files & Folders)
    #__INST dolphin                                    #File Browser
    #__INST bluefish                                   #Text editor
    __INST evince                                      #Pdf viewer
    __INST xournal                                     #Pdf note taking
    #__INST zim                                        #Notes create

    # Sublime text editor
    #__ADDREP ppa:webupd8team/sublime-text-3              
    #__INST sublime-text-installer
    #__INST subliminal

    # LaTex
    #__INST texlive-full                                #Full
    __INST texlive texlive-base                        #Light

    # LaTex Editor
    __INST texmaker

    # Atom text editor
    #__ADDREP ppa:webupd8team/atom                        
    #__INST atom
}

games(){
    __INST hedgewars                                   #Worms game

    # This is not actually a game, fortune  
    # is a program that displays a random 
    # message from a database of quotations
    __INST fortune-mod
}

media(){
    __INST vlc browser-plugin-vlc                      #VLC player
    __INST tomahawk                                    #Music player
    __INST easytag                                     #Tags editing tool for audio/video files
    #__INST clementine                                 #Music player

    # KODI media center
    #__INST software-properties-common                  
    #__ADDREP ppa:team-xbmc/ppa
    #__INST kodi
}

net() {
    __INST chromium-browser                            #Browser
    __INST youtube-dl                                  #Video download
}

pentest(){
    __INST linssid                                     #Wireless access points informations
    __INST etherape                                    #Network mapping tool 
    __INST wireshark                                   #Network packages tool
    __INST aircrack-ng                                 #Network tool
    __INST nmap                                        #Network mapping tool
    __INST zenmap                                      #GUI Network mapping tool
    __INST john                                        #Decrypt passwords, hashes etc...  
    __INST macchanger                                  #Change Mac address
    __INST bless                                       #Hex editor
    __INST steghide                                    #Steganography program
    __INST cmatrix                                     #Just for fun xD, matrix style on terminal
    __INST traceroute                                  #Displays the route used by IP packets
    __INST whois                                       #Whois protocol client
}

peripheral(){
    #Mapping extra mouse and keyboard actions
    #E.g. using MX Master 2S: 
    #https://wiki.archlinux.org/index.php/Logitech_MX_Master?fbclid=IwAR0o3Tc3F7rpyLLFS834RhIIcE12KP9AuqUCkMZroTe7cZn2UWru7vKNKc8
    __INST xbindkeys xautomation                       

    __INST solaar                                    #Logitech Unifying Receiver peripherals manager for Linux 

    __INST autokey-qt                                #Desktop automation utility
    __INST xdotool                                   #Simulate X11 keyboard/mouse input events
}

# If you want to start on boot some applications just use this function
# As a matter of fact, this function uses __START which just creates desktop 
# entries on ~/.config/autostart directory
startOnBoot(){
    __START -n 'Alarm-Clock' -e 'alarm-clock-applet --hidden'                
    __START -n 'Caffeine' -e '/usr/bin/caffeine'  

    __START -n 'caffeine-indicator' -e 'caffeine-indicator' -hf -ndf -gt                    
    #__START -n 'Num_Caps-lock' -e 'indicator-keylock' -hf -ndf -gt                   
    __START -n 'Parcellite' -e 'bash -c "parcellite &"' -c 'Clipboard Manager' -i 'parcellite' -tf -gt               
    __START -n 'Psensor' -e 'psensor' -hf -ndf -gt                                
    #__START -n 'Skype' -e '/usr/bin/skypeforlinux' -i 'skypeforlinux' -tf -sf -gt                 
    #__START -n 'synergy' -e 'synergy' -hf -ndf -gt                               
    __START -n 'System-load-indicator' -e 'indicator-multiload' -i 'utilities-system-monitor' -tf -gt                   
    __START -n 'Viber' -e '/opt/viber/Viber' -hf -ndf -gt                       
    #__START -n 'xbindkeys' -e 'xbindkeys' -ht -ndf -gt 

    __START -n 'Firefox' -e 'firefox' -tf -i 'firefox'                              
}

system(){
    #sudo apt-get remove unity-lens-shopping          #Unity Dash search remove
    __INST software-properties-common                 #Extra softwate packages install
    __INST network-manager                            #Network-Manager
    __INST gparted                                    #Partition-editing application
    __INST htop                                       #Interactive process viewer
    __INST synergy                                    #Mouse and Keyboard sharing Software
    __INST dconf-tools                                #Low-level configuration system for GSettings
    __INST expect                                     #Automate events using expected words tool
    __INST hardinfo                                   #System useful informations
    __INST openvpn                                    #VPN configuring                         
    __INST caffeine                                   #Easily enable/disable screensaver applet
    __INST psensor                                    #System Temps
    __INST parcellite                                 #Clipboard manager Applet
    __INST indicator-multiload                        #Graphical system load indicator for CPU, ram, etc
    __INST alarm-clock-applet                         #Alarm clock 
    __INST gnome-system-monitor                       #System Monitor
    #__INST unity-tweak-tool                           #Unity GUI customization tool
    __INST gnome-tweak-tool                           #Gnome GUI customization tool
    __INST clamav clamtk                              #Open source antivirus engine with GUI
    __INST indicator-keylock                          #Num/Caps lock indicator
    __INST tmux                                       #Terminal multiplexer
    __INST exfat-fuse exfat-utils                     #Mount exfat file system

    #Compiz Settings Manager
    __INST compizconfig-settings-manager 
    __INST compiz-plugins-extra

    #__INST xsensors lm-sensors                       #Sensors (Use $sensors-detect)
    #__INST openjdk-8-jdk
    #__INST wallch                                    #Wallpaper Clock
    #__INST kazam									  #Screen recording
    #__INST bacula									  #Backup System

    #Python 3.6
    #__ADDREP ppa:jonathonf/python-3.6				  
    #__INST python3.6

    #Numix theme
    #__ADDREP ppa:numix/ppa                              
    #__INST numix-gtk-theme numix-icon-theme-circle numix-wallpaper-notd
}

web(){
    #Download manager
    #__ADDREP ppa:plushuang-tw/uget-stable
    #__INST uget

    __INST qbittorrent								   #Torrent client
    __INST filezilla                                   #File transfer application
}

full(){
    contentCreate 
    codeDevelopment 
    engineering 
    files 
    games
    media 
    net 
    pentest
    peripheral
    system 
    web
    #startOnBoot
}

light(){
    files
    media
    net
    peripheral
    system
}

#MAIN
while :
do
    case "$1" in
        -c | --content)     __UPDG ; contentCreate ;   shift ;;
        -d | --develop)     __UPDG ; codeDevelopment ; shift ;;
        -e | --engineering) __UPDG ; engineering ;     shift ;;
        -f | --files)       __UPDG ; files ;           shift ;;
        -g | --games)       __UPDG ; games ;           shift ;;
        -h | --help)        	     helpMenu ;        exit 0;;
        -m | --media)       __UPDG ; media ;           shift ;;
        -n | --net)         __UPDG ; net ;             shift ;;
        -o | --onboot)               startOnBoot;      exit 0;;
        -p | --pentest)     __UPDG ; pentest ;         shift ;;
        -l | --peripheral)  __UPDG ; peripheral;       shift ;;
        -s | --system)      __UPDG ; system ;          shift ;;
        -w | --web)         __UPDG ; web ;             shift ;;

        -F | --Full)        __UPDG ; full ; break ;; 

        -L | --Light)       __UPDG ; light ; shift ;;

        --*)
            echo "Unknown option: $1" >&2
            helpMenu
            exit 1
            ;;
        -*)
            echo "Unknown option: $1" >&2
            helpMenu
            exit 1 
            ;;
        *) 
            break
    esac
done
__UPDG
__INFO