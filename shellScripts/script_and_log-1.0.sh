#!/bin/bash
#####################################################################################################################
#
#   script_and_log-1.0.sh
#
#   Author : Spyridakis Christos
#   Create Date : 28/2/2019
#   Last Update : 28/2/2019
#   Email : spyridakischristos@gmail.com
#
####################################################################################################################

#Init variables
FILE_NAME='ADD_YOUR_LOG_FILE_NAME'
FILE_PATH='/PATH/TO/THIS/FILE'
MESSAGE='MESSAGE_YOU_WANT_TO_PRINT'

FILE_EXTENSION='txt'

#Create paths
FILE="${FILE_PATH}/${FILE_NAME}.${FILE_EXTENSION}"
TMP="${FILE_PATH}/${FILE_NAME}_TEMP.${FILE_EXTENSION}"

##################
#Put commands here
##################

#Create log file or insert data at the beginning
if [ -e ${FILE} ] ; then
	cp ${FILE} ${TMP}
	(echo ${MESSAGE} && date -R && echo && cat ${TMP}) > ${FILE}
	rm ${TMP}
else
	(echo ${MESSAGE} && date -R) > ${FILE}
fi





