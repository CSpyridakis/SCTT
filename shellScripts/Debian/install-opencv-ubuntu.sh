#!/bin/bash
#
#   Author: Spyridakis Christos
#   Creation Date: 20/5/2021
#   Last update: 8/6/2021
#
#   Description:
#       Install OpenCV - on a Debian based OS (tested on Ubuntu 18.04.4 LTS) -
#       from source files (get them from github), build code in
#       ~/Documents/OpenCV/ directory, install binaries & executables to /usr/local/
#       and create a simple usage example on ~/Desktop/OpenCV-examples/
#
#       Instructions based on official Documentation
#       https://docs.opencv.org/master/d7/d9f/tutorial_linux_install.html
#
#

BUILD_DIR="~/Documents/OpenCV/build"
OPENCV_DIR="~/Documents/OpenCV"
EXAMLES_DIR="~/Desktop/OpenCV-examples"
QT_enabled="true"
CAMERA_RES_PROBLEM="true"
EXTRA_MODULES="false"
CMAKE_LOG_FILE="cmake-log.txt"

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`
procNumber=$(nproc --all)

###############################################################################
# Install OpenCV
###############################################################################

installPrerequisites(){
    sudo apt update
    echo -e "${yellow}[Update Finished - install basic packages]${reset}\n"
    sudo apt install -y cmake g++ wget unzip make pkg-config

    echo -e "${yellow}[For image files in a particular format]${reset}\n"
    sudo apt-get install -y libjpeg-dev libtiff5-dev libpng-dev

    echo -e "${yellow}[For video files in a particular codec]${reset}\n"
    sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libxvidcore-dev libx264-dev libxine2-dev

    echo -e "${yellow}[highgui module to show images or videos]${reset}\n"
    sudo apt-get install -y libgtk2.0-dev

    echo -e "${yellow}[support OpenGL]${reset}\n"
    sudo apt-get install -y mesa-utils libgl1-mesa-dri libgtkgl2.0-dev libgtkglext1-dev  

    echo -e "${yellow}[OpenCV optimization]${reset}\n"
    sudo apt-get install -y libatlas-base-dev gfortran libeigen3-dev

    if [ ${QT_enabled} == "true" ] ; then 
        echo "${yellow}[Install QT]${reset}"
        sudo apt-get install -y qtbase5-dev qtdeclarative5-dev
        echo -e "${yellow}[QT-enabled]${reset}\n"
    else
        echo -e "${yellow}[QT-disabled]${reset}\n"
    fi

    if [ ${CAMERA_RES_PROBLEM} == "true" ] ; then 
        echo "${yellow}[Install V4L and Gstreamer]${reset}"
        sudo apt-get install -y libv4l-dev 
        sudo apt-get install -y v4l-utils 
        sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
        echo "${yellow}[LIB V4L-enabled]${reset}"
        echo "${yellow}[Please Run: v4l2-ctl -d0 --list-formats-ext]${reset}"
    else
        echo "${yellow}[LIB V4L-disabled]${reset}"
    fi

    echo -e "${green}Prerequisites Installed${reset}\n"
}

downloadOpenCV(){
    cd ~
    OPENCV_ON="$(pwd)/${OPENCV_DIR:2}/"
    BUILD_ON="$(pwd)/${BUILD_DIR:2}/"
    mkdir -p ${OPENCV_ON} && cd ${OPENCV_ON}

    # Download and unpack sources
    wget -O opencv.zip https://github.com/opencv/opencv/archive/master.zip
    unzip opencv.zip

    # Create build directory
    mkdir -p ${BUILD_ON}

    echo "${green}Sources Downloaded${reset}"
}

configureOpenCV(){
    cd ~
    BUILD_ON="$(pwd)/${BUILD_DIR:2}/"

    if [ -d "${BUILD_ON}" ] ; then
        cd ${BUILD_ON}
        arguments="-D CMAKE_BUILD_TYPE=RELEASE "
        arguments+="-D CMAKE_INSTALL_PREFIX=/usr/local "
        arguments+="-D INSTALL_C_EXAMPLES=ON "
        arguments+="-D BUILD_EXAMPLES=ON "
        arguments+="-D WITH_OPENGL=ON "

        if [ ${EXTRA_MODULES} == "true" ] ; then
            arguments+="-D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules "
        fi

        if [ ${QT_enabled} == "true" ] ; then 
            arguments+="-D WITH_QT=ON "
        fi

        if [ ${CAMERA_RES_PROBLEM} == "true" ] ; then 
            arguments+="-D WITH_V4L=ON "
            arguments+="-D WITH_LIBV4L=ON "
            arguments+="-D WITH_GSTREAMER=ON "
        fi
        echo -e "${yellow}[RUN] - cmake ${arguments} ../opencv-master${reset}\n\n"
        cmake ${arguments} ../opencv-master 2>&1 | tee ${CMAKE_LOG_FILE}
        echo "${yellow}[JUST RUN] - cmake ${arguments} ../opencv-master${reset}"
        echo "${green}Configuration Finished${reset}"
    else
        echo "${red}First download OpenCV sources ${reset}"
        echo "${yellow}Run: $0 -h${reset}"
    fi
}

buildAndInstall(){
    cd ~
    BUILD_ON="$(pwd)/${BUILD_DIR:2}/"

    if [ -d "${BUILD_ON}" ] ; then
        cd ${BUILD_ON}
        make -j${procNumber}
        sudo make install
        echo "${green}OpenCV successfully installed!${reset}"
    else
        echo "${red}First download and configure OpenCV sources ${reset}"
        echo "${yellow}Run: $0 -h${reset}"
    fi
}

uninstallOpenCV(){
    cd ~
    OPENCV_ON="$(pwd)/${OPENCV_DIR:2}/"
    BUILD_ON="$(pwd)/${BUILD_DIR:2}/"
    EXAMPLES_ON="$(pwd)/${EXAMLES_DIR:2}/"

    #Delete examples
    echo "${yellow}1. Remove examples${reset}"
    rm -rf ${EXAMPLES_ON}

    #Uninstall from system
    cd ${BUILD_ON}
    echo "${yellow}2. Remove installation from system${reset}"
    sudo make uninstall || echo "${yellow}There is not build yet..${reset}"
    
    #Delete build files
    cd ${OPENCV_ON}
    echo "${yellow}3. Remove build${reset}"
    rm -rf build/
    mkdir -p ${BUILD_ON}
    
    echo "${yellow}Successfully Uninstalled${reset}"
}

installOpenCV(){
    installPrerequisites
    downloadOpenCV
    configureOpenCV
    buildAndInstall
}

###############################################################################
# Create a simple example
###############################################################################
# Alternatively create a Makefile with this content: g++ TestOpenCV.cpp `pkg-config opencv --cflags --libs` -o TestOpenCV
createExampleProject(){
    echo "${yellow}Create Example Project!${reset}"
    cd ~
    EXAMPLES_ON="$(pwd)/${EXAMLES_DIR:2}/"
    mkdir -p ${EXAMPLES_ON} && cd ${EXAMPLES_ON}

    # Clean files
    echo '#!/bin/bash
    rm -rf CMakeFiles cmake_install.cmake CMakeCache.txt TestOpenCV Makefile' > clean && chmod +x clean

    # Build files
    echo '#!/bin/bash
    cmake .
    make' > build && chmod +x build 

    # Run executable
    echo '#!/bin/bash
    ./TestOpenCV' > run && chmod +x run 

    # CMakeLists.txt
    echo 'cmake_minimum_required(VERSION 2.8)
    project( TestOpenCV )
    find_package( OpenCV REQUIRED )
    include_directories( ${OpenCV_INCLUDE_DIRS} )
    add_executable( ${PROJECT_NAME} TestOpenCV.cpp )
    target_link_libraries( ${PROJECT_NAME} ${OpenCV_LIBS} )' > CMakeLists.txt

    # Main
    echo '#include <stdio.h>
    #include <opencv2/opencv.hpp>

    using namespace cv;

    int main(int argc, char** argv ){
        Mat image = imread( "OpenCV-logo.png", 1 );
        if ( !image.data ){
            printf("No image data \n");
            return -1;
        }
        namedWindow("Display Image", WINDOW_NORMAL );
        resizeWindow("Display Image", 800, 600);
        imshow("Display Image", image);
        waitKey(0);
        return 0;
    }' > TestOpenCV.cpp

    # Get example image
    wget -O OpenCV-logo.png https://upload.wikimedia.org/wikipedia/commons/thumb/3/32/OpenCV_Logo_with_text_svg_version.svg/1200px-OpenCV_Logo_with_text_svg_version.svg.png
}


###############################################################################

helpMenu(){
    echo "Usage: $0 [Option].. [Option].."
    echo "Install OpenCV on a Debian-based system"
    echo 
    echo "Options:"
    echo "  -b, --build             Build sources with make and install to your system OpenCV libs and executables"
    echo "  -c, --configure         Configure using CMake"
    echo "  -d, --download          Download OpenCV sources from official GitHub page to ${OPENCV_DIR}/"
    echo "  -e, --examples          Create basic examples to your ${EXAMLES_DIR}/"
    echo "  -i, --install           Download, Configure, Build and Install OpenCV"
    echo "  -p, --prerequisites     Install prerequisites"
    echo "  -u, --uninstall         Uninstall and remove build files"
}

#MAIN
while :
do
    case "$1" in
        -b | --build)               buildAndInstall;        shift ;;
        -c | --configure)           configureOpenCV;        shift ;;
        -d | --download)            downloadOpenCV;         shift ;;
        -e | --examples)            createExampleProject ;  shift ;;
        -h | --help)                helpMenu ;              shift ;;
        -i | --install)             installOpenCV;          shift ;;
        -p | --prerequisites)       installPrerequisites;   shift ;;
        -u | --uninstall)           uninstallOpenCV ;       shift ;;

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