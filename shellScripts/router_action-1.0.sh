#!/usr/bin/expect
#####################################################################################################################
#
#   router_action-1.1.sh
#
#   Author : Spyridakis Christos
#   Created Date : 1/4/2019
#   Last Updated : 1/4/2019
#   Email : spyridakischristos@gmail.com
#
#   Description : 
#       This script uses telnet protocol in order to establish a connection with your router
#       and execute a predefined action (e.g. reboot)
#
#   Additional Comments : 
#       The expected messages may vary based on router. In order to use this script 
#       without problems, you need to connect to your router once using a terminal 
#       and change expect messages as needed
#
#   Dependences : 
#       - expect 
#               If you are in a Debian-Based system install it by executing: 
#               sudo apt-get install expect 
#
####################################################################################################################

set timeout 20
set echo  off

#----------------------------------------
#           Initialize variables
#----------------------------------------

# CHANGE BELOW VARIABLES' VALUES 
# ACCORDING TO YOUR NEEDS 
#
# Device's IP address
set routerip 192.168.X.X       
# Use your username
set name username
# Use your password        
set pass password   
# Desired action         
set comd reboot                 

#----------------------------------------
#          Establish connection
#----------------------------------------
spawn telnet ${routerip}

#----------------------------------------
#    Authenticate user and send command
# ----------------------------------------
# Send username 
expect "Login: " #sleep .1;
send "${name}\r"
# Send password
expect "Password: "
send "${pass}\r"
# Send action
expect ">"
send "${comd}\r"
