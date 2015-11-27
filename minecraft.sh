#!/bin/bash
set -xe

cd /tmp

# Trying to find out what it's the forge recommanded version, and with what minecraft version
FORGEVER="http://files.minecraftforge.net/maven/net/minecraftforge/forge/promotions_slim.json"
RECOMMENDEDFORGE=$( wget -O - $FORGEVER 2>/dev/null | grep '"recommended":' | awk '{print $2}' | tr -d \" | tr -d '[[:space:]]' )
RECOMMENDEDMINE=$( wget -O - $FORGEVER 2>/dev/null | grep $RECOMMENDEDFORGE | grep -v '"recommended"' | awk '{print $1}' | tr -d \" | tr -d \: | tr -d '[[:space:]]' | awk -F \- '{print $1}' )
FORGEVERSION="$RECOMMENDEDMINE-$RECOMMENDEDFORGE"

# Download forga and minecraft
wget http://files.minecraftforge.net/maven/net/minecraftforge/forge/$FORGEVERSION/forge-$FORGEVERSION-universal.jar
wget "https://s3.amazonaws.com/Minecraft.Download/versions/$RECOMMENDEDMINE/minecraft_server.$RECOMMENDEDMINE.jar"

# Go to the data dir and run the forge installer and then the minecraft server
exec java -jar /tmp/forge-$FORGEVERSION-universal.jar --installServer
cd /srv
echo "eula=true" > eula.txt
exec java -Xms512M -Xmx900M -jar /tmp/minecraft_server.$RECOMMENDEDMINE.jar
