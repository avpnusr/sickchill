![SickRage Logo](https://user-images.githubusercontent.com/390379/47651259-f1be4000-db3f-11e8-895f-bae17d5ca467.png)
**SickChill in docker container (german version)**
====
Image is created in auto-build for x86 based systems.
Image is created on TinkerBoard, Raspberry Pi, Rock64 or AWS for ARM based systems.

Versions in latest image
---
The image is based on the latest **[SickChill](https://github.com/SickChill/SickChill "SickChill GitHub")** version. I only updated the settings, to not ignore the german releases (for convenience).

Start your container
-----
For **[/cfg+db/location]**, use the volume, where your config-file and the database from SickRage is stored.

For **[/incoming/folder]**, you can use the volume, where the files will be stored, that SickRage should process.

For **[/media/folder]**, use the volume, where the postprocessed files will be stored.

You can set the timezone for the container via environment-variable "TZ".
You can activate support for german releases via the environment-variable "GERMAN".

```
docker run -d \
  -v [/cfg+db/location]:/data \
  -v [/incoming/folder]:/incoming \
  -v [/media/folder]:/media \
  -e UID=[Users UID] \
  -e GID=[Users GID] \
  -e TZ="Europe/Berlin" \
  -e GERMAN=true \
  -p 8081:8081 \
  --name sickchill \
  --restart=unless-stopped avpnusr/sickchill
```
