#!/bin/bash
############################################################

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
mkfs.xfs /dev/xvdd
echo "/dev/xvdd   /data xfs defaults 0 0 " >> /etc/fstab

mkdir /data
mount /data
mkdir -vp /data/{home,ci}

exit 0
