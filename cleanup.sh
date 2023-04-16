#!/bin/bash
#echo "Stopping the deployment"
#docker-compose stop blog
#echo "Cleaning up the local server..."
#echo "Removing the deployment"
#docker-compose rm blog

BLOGIMG=`sudo docker images | grep blogimg | awk '{print $1}'`

if [ $BLOGIMG == 'blogimg' ]; then
    echo "Removing the temp image"
    sudo docker image rm blogimg
    echo "Done"
else
    echo "All clean..."
fi



