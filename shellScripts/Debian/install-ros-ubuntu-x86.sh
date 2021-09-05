#!/bin/bash
#
#   Author: Spyridakis Christos
#   Creation Date: 11/8/2021
#   Last update: 5/9/2021
#
#   Description:
#       Install ROS (Robot Operating System) melodic or noetic version - on Ubuntu OS
#
#       Instructions based on official Documentation
#       https://docs.opencv.org/master/d7/d9f/tutorial_linux_install.html
#
#
#   Extra:

LOG_FILENAME="${HOME}/install-ros-ubuntu-x86-log.txt"

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`
procNumber=$(nproc --all)

echoe(){
    echo "${red}[ERRO]${reset} $@" | tee -a "${LOG_FILENAME}"
}

echoi(){
    echo "${yellow}[INFO]${reset} $@" | tee -a "${LOG_FILENAME}"
}

ROS_DISTRO=""
INST_TYPE=""

helpMenu(){
    echo "Usage: $0 [Option] [Option]"
    echo "Install ROS (Robot Operating System) melodic or noetic version - on Ubuntu OS"
    echo 
    echo "Options:"
    echo "  -b, --base                 install base version of ROS"
    echo "  -d, --desktop              install desktop version of ROS"
    echo "  -f, --full                 install desktop-full version of ROS"
    echo "  -h, --help                 print this help menu and exit"
    echo "  -m, --melodic              install melodic distro of ROS"
    echo "  -n, --noetic               install noetic distro of ROS"
}

installation(){
    
    # Setup your sources.list
    echoi "Setup your sources.list"
    sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

    # Set up your keys
    echoi "Set up your keys"
    sudo apt -y install curl # if you haven't already installed curl
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

    # Installation
    sudo apt -y update

    if [ "${INST_TYPE}" == "full" ] ; then
        echoi "Full Installation"
        sudo apt -y install ros-${ROS_DISTRO}-desktop-full    # Desktop-Full Install
    elif [ "${INST_TYPE}" == "desktop" ] ; then 
        echoi "Desktop Installation"
        sudo apt -y install ros-${ROS_DISTRO}-desktop       # Desktop Install
    elif [ "${INST_TYPE}" == "base" ] ; then
        echoi "Base Installation"
        sudo apt -y install ros-${ROS_DISTRO}-ros-base      # ROS-Base
    fi

    # Environment setup
    echoi "Environment setup"
    [ ${SHELL} = "/usr/bin/zsh" ] && (echo -e "\nsource /opt/ros/${ROS_DISTRO}/setup.zsh \n" >> ~/.zshrc && source ~/.zshrc)

    # Dependencies for building packages
    echoi "Install dependencies for building packages"
    sudo apt -y install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential

    # Initialize rosdep
    echoi "Initialize rosdep"
    sudo apt -y install python3-rosdep
    sudo rosdep init
    rosdep update

    echoi "Installation Completed Successfully!"
}

while :
do
    case "$1" in
        -b | --base)      INST_TYPE="base" ; shift ;;
        -d | --desktop)   INST_TYPE="desktop" ; shift ;;
        -f | --full)      INST_TYPE="full" ; shift ;;
        -h | --help)      helpMenu ; exit 0 ;; 
        -m | --melodic)   ROS_DISTRO="melodic" ; shift ;;
        -n | --noetic)    ROS_DISTRO="noetic"  ; shift ;;
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

if [ ! -z ${INST_TYPE} ] && [ ! -z ${ROS_DISTRO} ] ; then
    installation
else
    echo "Please give installation type and ros distro to install. "
    echo "Run ./`basename $0` -h for more"
fi
