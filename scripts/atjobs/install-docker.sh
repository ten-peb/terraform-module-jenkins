#!/bin/bash
########################################################################
## An "at"  script intoned during provisioning stage of  system build
##
## 
##
## Purpose:
##   1. Installs docker-ce from the docker.io apt repository
##   2. Installs docker-compose
##   3. Installs docker-machine
##
## Dependencies:
##   1. /data volume exists and is mounted
##   2. Puppet agent is installed
##
## Author: Peter L. Berghold  <pberghold@tenna.com>
## -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-


### loop until the data volume has been mounted
while [ ! -d /data/ci ]; do sleep 30 ; done
export DEBIAN_FRONTEND=noninteractive

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get -y install \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg-agent \
	software-properties-common

apt-get install -y docker-ce docker-ce-cli containerd.io

###
### Make sure the puppet agent has been installed
### before proceding

while[ ! -f /opt/puppetlabs/bin/puppet ]; do sleep 30 ; done

export PATH=${PATH}:/opt/puppetlabs/bin

puppet apply -e 'service{"docker":ennsure=>stopped,enable=false}'

cd /var/lib
mkdir -pv /data/virt/docker
mv docker docker.old
ln -s /data/virt/docker docker
cd docker.old
find . -depth -print | cpio -pdmv /data/virt/docker/

puppet apply -e 'service{"docker":ennsure=>running,enable=true}'

cd /var/lib
rm -rf docker.old

## Install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod 755 /usr/local/bin/docker-compose

## Install docker-machine
base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  sudo install /tmp/docker-machine /usr/local/bin/docker-machine
## fini
exit 0
