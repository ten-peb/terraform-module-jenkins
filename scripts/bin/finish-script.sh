#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get -y dist-upgrade
apt-get -y install build-essential ruby nodejs apt-utils 
apt-get -y install openjdk-8-jdk openjdk-8-jre mailutils tree 

for e in /opt/syssetup/*.sh
do
    chmod 755 ${e}
    echo "Stardting ${e}" >> /var/log/provision/provision.log
    ${e} 2>&1 >> /var/log/provision/provision.log
done



