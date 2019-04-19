#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get -y dist-upgrade
apt-get -y install build-essential ruby nodejs apt-utils
apt-get -y install openjdk-8-jdk openjdk-8-jre mailutils 

for e in /opt/syssetup/*.sh
do
    chmod 755 ${e}
    ${e}
done



