#!/usr/bin/env bash

echo "restart mysql service"
if [ "$1" = "debian11" ] || [ "$1" = "debian12" ]; then
    docker exec --user root ndts service mariadb restart
else
    # workaround for a bug in debian9, i.e. starting mysql hangs
    docker exec --user root ndts service mysql stop
    if [ "$1" = "ubuntu20.04" ] || [ "$1" = "ubuntu20.10" ] || [ "$1" = "ubuntu21.04" ] || [ "$1" = "ubuntu22.04" ] || [ "$1" = "ubuntu23.10" ]; then
	docker exec --user root ndts /bin/bash -c 'usermod -d /var/lib/mysql/ mysql'
    fi
    # docker exec  --user root ndts /bin/bash -c '$(service mysql start &) && sleep 30'
    docker exec --user root ndts service mysql start
fi

echo "install tango-db and tango-common"
docker exec  --user root ndts /bin/bash -c 'apt-get -qq update; apt-get -qq install -y   tango-db tango-common; sleep 10'
if [ "$?" != "0" ]; then exit 255; fi

if [ "$1" = "ubuntu20.04" ] || [ "$1" = "ubuntu20.10" ] || [ "$1" = "ubuntu21.04" ] || [ "$1" = "ubuntu21.10" ] || [ "$1" = "ubuntu22.04" ] || [ "$1" = "ubuntu23.10" ]; then
    docker exec  --user root ndts /bin/bash -c 'echo -e "[client]\nuser=tango\nhost=127.0.0.1\npassword=rootpw" > /var/lib/tango/.my.cnf'
    docker exec  --user root ndts /bin/bash -c 'echo -e "[client]\nuser=root\npassword=rootpw" > /root/.my.cnf'
fi

docker exec  --user root ndts service tango-db restart
if [ "$?" != "0" ]; then exit 255; fi


echo "install tango servers"
docker exec  --user root ndts /bin/bash -c 'apt-get -qq update; apt-get -qq install -y  tango-starter tango-test'
if [ "$?" != "0" ]; then exit 255; fi

docker exec  --user root ndts service tango-starter restart
if [ "$?" != "0" ]; then exit 255; fi
docker exec  --user root ndts chown -R tango:tango .

echo "install pytango and nxsconfigserver-db"
if [ "$2" = "2" ]; then
    docker exec  --user root ndts /bin/bash -c 'apt-get -qq update; apt-get -qq install -y   python-pytango nxsconfigserver-db; sleep 10'
else
    if [ "$1" = "debian10" ] || [ "$1" = "ubuntu23.10" ] || [ "$1" = "ubuntu22.04" ] || [ "$1" = "ubuntu20.04" ] || [ "$1" = "ubuntu20.10" ] || [ "$1" = "debian11" ] || [ "$1" = "debian12" ] ; then
	docker exec --user root ndts /bin/bash -c 'apt-get -qq update; apt-get -qq install -y   python3-tango nxsconfigserver-db; sleep 10'
    else
	docker exec  --user root ndts /bin/bash -c 'apt-get -qq update; apt-get -qq install -y   python3-pytango nxsconfigserver-db; sleep 10'
    fi
fi
if [ "$?" != "0" ]; then exit 255; fi


echo "install nxsconfigserver"
if [ "$2" = "2" ]; then
    docker exec --user root ndts chown -R tango:tango .
    docker exec  ndts python setup.py build
    docker exec --user root ndts python setup.py  install
else
    docker exec --user root ndts chown -R tango:tango .
    docker exec  ndts python3 setup.py build
    docker exec --user root ndts python3 setup.py  install
fi
if [ "$?" != "0" ]; then exit 255; fi
