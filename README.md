![SickRage Logo](https://user-images.githubusercontent.com/390379/47651259-f1be4000-db3f-11e8-895f-bae17d5ca467.png)
**SickChill in docker container (german version)**
====
Image is created in auto-build for x86 based systems.
Image is created on TinkerBoard, Raspberry Pi, Rock64 for ARM based systems.

Versions in latest image
---
The image is based on the latest **[SickRage](https://sickrage.github.io/ "SickRage Homepage")** version from **[cytec](https://github.com/cytec/SickRage "cytec SickRage")** which is a version, optimized specially for german users. 

On request, I will provide a version from the standard SickRage git.

Start your container
-----
For **[/cfg+db/location]**, use the volume, where your config-file and the database from SickRage is stored.

For **[/incoming/folder]**, you can use the volume, where the files will be stored, that SickRage should process.

For **[/media/folder]**, use the volume, where the postprocessed files will be stored.

You can set the timezone for the container via environment-variable "TZ".

```
docker run -d \
  -v [/cfg+db/location]:/data \
  -v [/incoming/folder]:/incoming \
  -v [/media/folder]:/media \
  -e UID=[Users UID] \
  -e GID=[Users GID] \
  -e TZ="Europe/Berlin" \
  -p 8081:8081 \
  --restart=always avpnusr/sickpi
```
