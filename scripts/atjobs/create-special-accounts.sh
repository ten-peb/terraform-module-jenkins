#!/bin/bash

export PATH=${PATH}:/opt/puppetlabs/bin

##
## First safety, ensure the EBS volume for /data has been mounted
while [ ! -d /data/home ] ; do sleep 30 ; done

## Second safety, ensure Puppet client has been installed

while [ ! -f /opt/puppetlabs/bin/puppet ] ; do sleep 30 ; done

## OK... now we can do our thing

puppet apply -f /opt/puppet-manifests/create_special_accounts.pp

## and we are done.

exit 0
