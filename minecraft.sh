#!/bin/bash
set -e

cd /tmp

# Trying to find out what it's the forge recommanded version, and with what minecraft version
FORGEVER="http://files.minecraftforge.net/maven/net/minecraftforge/forge/promotions_slim.json"
RECOMMENDEDFORGE=$( wget -O - $FORGEVER 2>/dev/null | grep '"recommended":' | awk '{print $2}' | tr -d \" | tr -d '[[:space:]]' )
RECOMMENDEDMINE=$( wget -O - $FORGEVER 2>/dev/null | grep $RECOMMENDEDFORGE | grep -v '"recommended"' | awk '{print $1}' | tr -d \" | tr -d \: | tr -d '[[:space:]]' | awk -F \- '{print $1}' )
FORGEVERSION="$RECOMMENDEDMINE-$RECOMMENDEDFORGE"

# Download forge and minecraft
if [ -e "forge-$FORGEVERSION-installer.jar" ]; then
  echo Allready downloaded forge-$FORGEVERSION-installer.jar
else
  wget "http://files.minecraftforge.net/maven/net/minecraftforge/forge/$FORGEVERSION/forge-$FORGEVERSION-installer.jar" 2>/dev/null
fi

if [ -e "minecraft_server.$RECOMMENDEDMINE.jar" ]; then
  echo Allready downloaded minecraft_server.$RECOMMENDEDMINE.jar
else
  wget "https://s3.amazonaws.com/Minecraft.Download/versions/$RECOMMENDEDMINE/minecraft_server.$RECOMMENDEDMINE.jar" 2>/dev/null
fi

# Go to the data dir and run the forge installer and then the minecraft server
cd /srv
cp -f /tmp/server.properties .

# OPS conf
if [ -n "$OPS" ]; then
  echo Operators=$OPS...
  rm -f ops*
  echo $OPS | awk -v RS=, '{print}' > ops.txt
fi

# SEED conf
if [ -n "$SEED" ]; then
  echo level-seed=$SEED...
  echo "level-seed=$SEED" >> server.properties
fi

# MTOD conf
if [ -n "$MTOD" ]; then
  echo MTOD=$MTOD...
  echo "mtod=$MTOD" >> server.properties
fi

java -jar /tmp/forge-$FORGEVERSION-installer.jar --installServer >/dev/null 2>&1
echo "eula=true" > eula.txt
exec java -Xms512M -Xmx900M -jar /tmp/minecraft_server.$RECOMMENDEDMINE.jar
