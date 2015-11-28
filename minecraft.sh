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

# MOTD conf
if [ -n "$MOTD" ]; then
  echo MOTD=$MOTD...
  echo "motd=$MOTD" >> server.properties
fi

# MAP conf
if [ -n "$MAP" ]; then
  echo MAP=$MAP...
  echo "level-name=$MAP" >> server.properties
else
  level-name=world >> server.properties
fi

# CLEANMAP conf
if [ "$CLEANMAP" = "true" ] && [ -n "$MAP" ] ; then
  echo CLEANMAP=$CLEANMAP...
  rm -Rf $MAP
fi

# Gravatar icon
if [ -n "$GRAVATAR" ] ; then
  echo GRAVATAR=$GRAVATAR...
  [ -f server-icon.jpg ] && rm -f server-icon.jpg
  [ -f server-icon.png ] && rm -f server-icon.png
  URL=$( echo -n "$GRAVATAR" | awk '{print tolower($0)}' | tr -d '\n ' | md5sum --text | awk '{print $1}' )
  wget -O server-icon.jpg http://www.gravatar.com/avatar/$URL?s=64 >/dev/null 2>&1
  convert server-icon.jpg server-icon.png
fi

java -jar /tmp/forge-$FORGEVERSION-installer.jar --installServer >/dev/null 2>&1
echo "eula=true" > eula.txt
tmux new "java -Xms512M -Xmx900M -jar /tmp/minecraft_server.$RECOMMENDEDMINE.jar"

