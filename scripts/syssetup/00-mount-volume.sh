#!/bin/bash
############################################################


echo "
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin

while [ ! -e /dev/xvdd ] ; do sleep 10; done 
mkfs.xfs /dev/xvdd
echo '/dev/xvdd   /data xfs defaults 0 0 ' >> /etc/fstab

mkdir /data
mount /data
mkdir -vp /data/{home,ci}

exit 0
" | at now
