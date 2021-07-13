#!/bin/sh
#####################################################################################################################
#
#   script_log-1.1.sh
#
#   Author : Spyridakis Christos
#   Created Date : 28/2/2019
#   Last Updated : 1/4/2019
#   Email : spyridakischristos@gmail.com
#
#   Description : 
#	Use this script if you want to run a sequence of commands and then save
#	to a log file the date and time of execution 
#		  
#	E.G. if you want to update or/and to updgrade your sustem using crontab 
#	once in a while and you need to have logs for this action you could put 
#	this script on crontab
#
#   Known Bugs:
#	You need to use a valid path, this means that FILE_PATH must exists	
#
####################################################################################################################

# CHANGE BELOW VARIABLES' VALUES ACCORDING TO YOUR NEEDS 
FILE_NAME='ADD_YOUR_LOG_FILE_NAME'
FILE_PATH='~/ABSOLUTE_PATH/TO/THIS/LOG/FILE'
MESSAGE='LOG_MESSAGE_YOU_WANT_TO_PRINT'
FILE_EXTENSION='txt'

# Create paths
FILE="${FILE_PATH}/${FILE_NAME}.${FILE_EXTENSION}"
TMP="${FILE_PATH}/${FILE_NAME}_TEMP.${FILE_EXTENSION}"

####################################
#
# 	  Put commands here
#
####################################

#Create directories that don't exist
if [ ! -d ${FILE_PATH} ] ; then
	#TODO : need to use Absolute path
	#mkdir -p ${FILE_PATH}
fi

#Create log file or insert log data at the beginning
if [ -e ${FILE} ] ; then
	cp ${FILE} ${TMP}
	(echo ${MESSAGE} && date -R && echo && cat ${TMP}) > ${FILE}
	rm ${TMP}
else
	(echo ${MESSAGE} && date -R) > ${FILE}
fi





