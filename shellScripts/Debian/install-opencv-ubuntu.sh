#!/bin/bash
#
#   Author: Spyridakis Christos
#   Create Date: 20/5/2021
#   Last update: 20/5/2021
#
#   Description:
#       Install OpenCV - on a Debian based OS (tested on Ubuntu 18.04.4 LTS) -
#       from source files (get them from github), build code in
#       ~/Documents/OpenCV directory, install binaries & executables to /usr/local
#       and create a simple usage example on ~/Desktop/OpenCV-example
#
#       Instructions based on official Documentation
#       https://docs.opencv.org/master/d7/d9f/tutorial_linux_install.html
#
#   Note:
#       If you want to uninstall OpenCV, run from inside OpenCV directory: sudo make uninstall 


###############################################################################
# Install OpenCV
###############################################################################

mkdir -p ~/Documents/OpenCV && cd ~/Documents/OpenCV/

# Install minimal prerequisites (Ubuntu 18.04 as reference)
sudo apt update && sudo apt install -y cmake g++ wget unzip make

# Download and unpack sources
wget -O opencv.zip https://github.com/opencv/opencv/archive/master.zip
unzip opencv.zip

# Create build directory
mkdir -p build && cd build

# Configure
cmake  ../opencv-master

# Build
cmake --build .

#Install
sudo make install


###############################################################################
# Create a simple example
###############################################################################

mkdir -p ~/Desktop/OpenCV-example && cd ~/Desktop/OpenCV-example

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