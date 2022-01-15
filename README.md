![SickRage Logo](https://user-images.githubusercontent.com/390379/47651259-f1be4000-db3f-11e8-895f-bae17d5ca467.png)

**SickChill in docker container (german version)**     
===

Image is created in auto-build for x86 based systems.
Image is created on TinkerBoard, Raspberry Pi, Rock64 or AWS for ARM(64) based systems.

Versions in latest image
---
The image is based on the version v2019.09.02-1 of **[SickChill](https://github.com/SickChill/SickChill "SickChill GitHub")**.    
I only updated some settings, to not ignore the german releases, and added glotz.info as indexer, if german ENV is set (for convenience).

Last build is from: **15/01/2022**

Status from last build
----
![SickChill Docker Build](https://github.com/avpnusr/sickchill/workflows/SickChill%20Docker%20Build/badge.svg)

Start your container
-----
**Important:** You should **really** use your own APIKEY from **[glotz.info](https://www.glotz.info)**, they are providing a great service for german airdates!

For **[/cfg+db/location]**, use the volume, where your config-file and the database from SickRage is stored.

For **[/incoming/folder]**, you can use the volume, where the files will be stored, that SickRage should process.

For **[/media/folder]**, use the volume, where the postprocessed files will be stored.

You can set the timezone for the container via environment-variable "TZ".    
You can activate support for german releases via the environment-variable "GERMAN".
You can set your own glotz.info APIKEY via the environment-variable "APIKEY".

**Important:** for german airdates, the language for indexers of SickChill needs to be set to "German / Deutsch" as well!

```
docker run -d \
  -v [/cfg+db/location]:/data \
  -v [/incoming/folder]:/incoming \
  -v [/media/folder]:/media \
  -e TZ="Europe/Berlin" \
  -e GERMAN=true \
  -e APIKEY=<glotz.info APIKEY> \
  [-e PUID=<uid> \]
  [-e PGID=<gid> \]
  -p 8081:8081 \
  --user=[UID:GID] \
  --name sickchill \
  --restart=unless-stopped avpnusr/sickchill
```
