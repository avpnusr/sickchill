#! /bin/sh
echo "### Checking if german language is selected ###"

if [ "$GERMAN" == "true" ]; then
	echo "### Detected German language, copying config ###"
	cp -f /__init__.py /sickchill/sickbeard/
	cp -f /indexer_config.py /sickchill/sickbeard/indexers/
	cp -f /showUpdater.py /sickchill/sickbeard/
	cp -f /tvdb_api.py /sickchill/lib/tvdb_api/
fi
echo " "
echo "### Starting SickChill ###"

/usr/bin/python /sickchill/SickBeard.py --nolaunch --datadir=/data --config=/data/config.ini 
