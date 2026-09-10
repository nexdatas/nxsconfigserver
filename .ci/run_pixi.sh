#!/usr/bin/env bash


echo "install pixi"
docker exec  ndts /bin/bash -c 'curl -fsSL https://pixi.sh/install.sh | sh ; export PATH=/var/lib/tango/.pixi/bin:$PATH ; cp .github/workflows/pixi/pixi.toml . ; pixi shell-hook  > .sh.sh ; source .sh.sh ; pixi add   numpy "pytango=10.1.4" setuptools pip wheel argcomplete lxml pytz pyyaml  python-dateutil pninexus fabio h5py matplotlib-base blissdata pytest docutils pymysql'

# # create nxsconfig database
# docker exec  --user root ndts /bin/bash -c 'source /home/tango/.sh.sh ; export MYSQL_PASSWORD="rootpw" ; create_nxsconfig_db -x -d=nxsonfig -u=tango -p="$CONDA_PREFIX"'

echo "run nxsconfigserver tests"
docker exec  ndts /bin/bash -c 'source .sh.sh ;  echo "export MYTANGO_PREFIX=$CONDA_PREFIX/bin" > /home/tango/.env ;   python -m pip install . -vv --no-deps --no-build-isolation ;   python -m pytest test'

ERROR=$?
if [ $ERROR -ne "0" ]
then
    echo "ERROR "$ERROR
    exit 255
fi
