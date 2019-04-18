#!/bin/bash

for e in /opt/syssetup/*.sh
do
    chmod 755 ${e}
    /opt/syssetup/${e}
done

apt-get update
apt-get -y dist-upgrade
apt-get -y install build-essentials ruby nodejs 


