#! /bin/sh

echo "### Bringing up crond for daily update of database ###"
/usr/sbin/crond -b

echo "### Starting SickRage v2018.09.17-1 ###"
echo "### Proudly manufactured by avnpusr ###"

/usr/bin/python SickBeard.py --nolaunch --datadir=/data --config=/data/config.ini 
