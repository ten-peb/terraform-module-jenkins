#!/bin/bash
############################################################


echo "
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
echo 'entering mount volumes'
while [ ! -e /dev/xvdd ] ; do sleep 10; done 
echo 'starting'

mkfs.xfs /dev/xvdd
echo '/dev/xvdd   /data xfs defaults 0 0 ' >> /etc/fstab

mkdir /data
mount /data
mkdir  /data/home 
mkdir  /data/ci
tree /data
echo 'done'
exit 0
" | at now
