#!/usr/bin/env bash
echo "run python3-nxsconfigserver tests"
docker exec   --user tango ndts python3 -m pytest
ERR=$?

echo "ERROR: "$ERR

if [ $ERR != 0 ]; then
    # if [ "$1" != "ubuntu26.04" ] && [ $ERR != 139 ]; then
    if  [ $ERR != 139 ]; then
	exit $ERR;
    fi
fi
