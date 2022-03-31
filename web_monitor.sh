#!/bin/bash
###################################################################
# Written by: Oscar Escamilla                                     #
# Purpose: Execute curl command to get HTTP response, then        #
#          execute action if response code is an error            #
# Date: 31.03.2018                                                #
###################################################################

# Retrieve HTTP status code
export STATUS=`curl -s -o /dev/null -w "%{http_code}" http://example.com/`

echo `date` # Print current date
echo "Status code: $STATUS"


if [ $STATUS == "200" ] # If 200 then OK
then
  echo "Status OK"
else # Else website is down
  echo "Status failed"
  echo "Starting..."
  # TODO: Use some script or action to start website
  # ...
fi
