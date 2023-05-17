#!/usr/bin/env bash
if [ "$2" = "2" ]; then
    echo "run python-nxsconfigserver tests"
    docker exec ndts python test
else
    echo "run python3-nxsconfigserver tests"
    if [ "$1" = "debian10" ] || [ "$1" = "ubuntu20.04" ] || [ "$1" = "debian11" ]|| [ "$1" = "ubuntu20.04" ] || [ "$1" = "ubuntu22.04" ]|| [ "$1" = "ubuntu23.04" ] ; then
	docker exec ndts python3 -m pytest
    else
	docker exec ndts python3 test
    fi
fi    
if [ "$?" != "0" ]; then exit -1; fi
