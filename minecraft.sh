#!/bin/bash
set -e

VERSIONSURL="https://s3.amazonaws.com/Minecraft.Download/versions/versions.json"
VERSION=$( wget -O - $VERSIONSURL 2>/dev/null | grep latest -2 | grep release | awk '{ print $2 }' | tr -d \" | tr -d '[[:space:]]' )
wget "https://s3.amazonaws.com/Minecraft.Download/versions/$VERSION/minecraft_server.$VERSION.jar"

cd /srv
echo "eula=true" > eula.txt

exec java -Xms512M -Xmx900M -jar /$SERVER
