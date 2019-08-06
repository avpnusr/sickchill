#! /bin/sh
echo "### Checking if german language is selected ###"

if [ "$GERMAN" == "true" ]; then
	echo "### Detected German language, copying config ###"
	mv -f /__init__.py /sickchill/sickbeard/__init__.py
fi

echo ""
echo "### Bringing up crond for daily update of database ###"
/usr/sbin/crond -b
echo ""
echo "### Starting SickChill ###"

/usr/bin/python /sickchill/SickBeard.py --nolaunch --datadir=/data --config=/data/config.ini 
