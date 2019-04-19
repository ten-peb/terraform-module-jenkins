#!/bin/bash
########################################################################

(
    cd /tmp
    wget http://apt.puppetlabs.com/puppet-release-bionic.deb
    dpkg -i puppet-release-bionic.deb
    apt-get update
    apt-get -y install puppet-agent
)

###### TOOD:  configure puppet agent to point to local Puppet master
######

exit 0
