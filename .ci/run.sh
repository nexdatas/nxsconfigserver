#!/usr/bin/env bash

if [ "$1" = "2" ]; then
    echo "run python-nxsconfigserver"
    docker exec  ndts python test
else
    echo "run python3-nxsconfigserver"
    docker exec  ndts python3 test
fi    
if [ "$?" -ne "0" ]
then
    exit -1
fi
