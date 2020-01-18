#! /bin/sh

# checking if environment-variable APIKEY is defined by user if not, standard key is set
echo "[INFO] Checking for user provided APIKEY"
if [ -z "$APIKEY" ]; then
  echo "[WARNING] You did not provide an APIKEY for glotz.info - setting default key"
  echo "[INFO] Please get your own and free APIKEY at https://www.glotz.info"
  APIKEY="2XCPYF1BF492M8CL"
else
  echo "[INFO] Setting your entered APIKEY: ${APIKEY}"
fi

# replacing commented out APIKEY with default or user given value
sed -i "s/'apikey':.*/'apikey': '${APIKEY}',/g" /indexer_config.py  

# checking if environment-variable GERMAN is set, if true the modified files are copied to sickchill folder
echo "[INFO] Checking if german language is selected"

if [ "$GERMAN" == "true" ]; then
  echo "[INFO] Detected German language, copying config"
  cp -f /__init__.py /sickchill/sickbeard/
  cp -f /indexer_config.py /sickchill/sickbeard/indexers/
  cp -f /showUpdater.py /sickchill/sickbeard/
  cp -f /tvdb_api.py /sickchill/lib/tvdb_api/
fi

if [ -n "$PUID" ] && [ -n "$PGID" ]; then
  echo "[INFO] You supplied userid $PUID and groupid $PGID"
fi

# set default values for userid, username, groupid and groupname if not set yet
PUID=${PUID:=15000}
PUSER=${PUSER:=app}
PGID=${PGID:=15000}
PGROUP=${PGROUP:=app}

# create internal APP group and user
# (which will be mapped to external group and user, and used to run the process)
GN=`getent group $PGID | awk -F':' '{print \$1}'`
if [ $GN ]; then
  echo "[WARNING] A group with id $PGID exists already [in use by $GN] and will be modified."
  # rename the existing group to the specified app group name
  echo "[WARNING] The group $GN will be renamed to $PGROUP"
  groupmod -n $PGROUP $GN
else
  echo "[INFO] Create group $PGROUP with id $PGID"
  # create group similar to:
  #  addgroup --gid $PGID $PGROUP
  addgroup -g $PGID $PGROUP
fi

UN=`getent passwd $PUID | awk -F':' '{print \$1}'`
if [ $UN ]; then
  echo "[WARNING] A user with id $PUID exists already [in use by $UN]."
  # create the specified app user name with the same user id (non-unique)
  TEMPORARY_PUID=999
  echo "[WARNING] Create user $PUSER with temporary user id $TEMPORARY_PUID."
  adduser -s /bin/bash -H -u $TEMPORARY_PUID -G $PGROUP -D -g "" $PUSER
  #-o, --non-unique ... when used with the -u option, this option allows to change the user ID to a non-unique value.
  echo "[WARNING] Assign non-unique user id $PUID to created user $PUSER"
  usermod -o -u $PUID $PUSER
else
  echo "[INFO] Create user $PUSER with id $PUID"
  #create user similar to:
  #  adduser --shell /bin/bash --no-create-home --uid $PUID --ingroup $PGROUP --disabled-password --gecos "" $PUSER
  adduser -s /bin/bash -H -u $PUID -G $PGROUP -D -g "" $PUSER
fi

echo " "
echo "[INFO] ### Starting SickChill ###"

if [ -n "$PUID" ] && [ -n "$PGID" ]; then
  echo "> change ownership to "
  chown -R $PUSER:$PGROUP /sickchill
  echo "> start via su-exec with userid $PUID and groupid $PGID"
  su-exec $PUSER:$PGROUP sh -c "/usr/bin/python /sickchill/SickBeard.py --nolaunch --datadir=/data --config=/data/config.ini"
else
  echo "> start as root"
  /usr/bin/python /sickchill/SickBeard.py --nolaunch --datadir=/data --config=/data/config.ini
fi
