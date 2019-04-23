#!/bin/bash

export PATH=${PATH}:/opt/puppetlabs/bin

##
## First safety, ensure the EBS volume for /data has been mounted
while [ ! -e /dev/xvdd ] ; do sleep 10; done 
while [ ! -d /data/home ] ; do sleep 300 ; done
while [ ! -d /data/ci ]; do sleep 300 ; done

tree /data/home

## Second safety, ensure Puppet client has been installed

while [ ! -f /opt/puppetlabs/bin/puppet ] ; do sleep 30 ; done

## OK... now we can do our thing
(
    echo "Starting account provision `date`" 
    puppet apply  /opt/puppet-manifests/create_special_accounts.pp
    echo "Starting account provision `date`"
    tree /data/home
) 2>&1 >> /var/log/provision/provision.log

## and we are done.

exit 0
