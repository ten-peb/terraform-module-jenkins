#!/bin/bash
########################################################################

(
    cd /tmp
    wget http://apt.puppetlabs.com/puppet-release-bionic.deb
    dpkg -i puppet-release-bionic.deb
    apt-get update
    apt-get -y install puppet-agent
)

echo "
[agent]

environment = dv1
" >> /etc/puppetlabs/puppet/puppet.conf

echo "
10.133.2.100 puppet puppet.dv1.tenna.com
10.133.2.100 puppetdb puppetdb.dv1.tenna.com
" >> /etc/hosts

echo "
#!/bin/bash

echo 'host_function=jenkins_host'

exit 0
" > /opt/puppetlabs/facter/facts.d/hostfunction.sh
chmod 755 /opt/puppetlabs/facter/facts.d/hostfunction.sh

/opt/puppetlabs/bin/puppet agent -t --waitforcert=1
/opt/puppetlabs/bin/puppet -e 'service{"puppet":ensure =>running,enable=true}"


exit 0
