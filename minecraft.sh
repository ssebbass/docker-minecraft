#!/bin/bash
set -e

# What we need to run all this
# apt-get update && apt-get install -y openjdk-8-jre screen wget <-- Step moved to image build

cd /tmp

# Trying to find out what it's the forge recommanded version, and with what minecraft version
FORGEVER="http://files.minecraftforge.net/maven/net/minecraftforge/forge/promotions_slim.json"
RECOMMENDEDFORGE=$( wget -O - $FORGEVER 2>/dev/null | grep '"recommended":' | awk '{print $2}' | tr -d \" | tr -d '[[:space:]]' )
RECOMMENDEDMINE=$( wget -O - $FORGEVER 2>/dev/null | grep $RECOMMENDEDFORGE | grep -v '"recommended"' | awk '{print $1}' | tr -d \" | tr -d \: | tr -d '[[:space:]]' | awk -F \- '{print $1}' )
FORGEVERSION="$RECOMMENDEDMINE-$RECOMMENDEDFORGE"

# Download forga and minecraft
echo "Downloading Forge $RECOMMENDEDFORGE & Minecraft $RECOMMENDEDMINE..."
wget "http://files.minecraftforge.net/maven/net/minecraftforge/forge/$FORGEVERSION/forge-$FORGEVERSION-installer.jar" 2>/dev/null
wget "https://s3.amazonaws.com/Minecraft.Download/versions/$RECOMMENDEDMINE/minecraft_server.$RECOMMENDEDMINE.jar" 2>/dev/null

# Go to the data dir and run the forge installer and then the minecraft server
echo Preparing server
cd /srv
if [ -n "$OPS" ]; then
  echo Operators=$OPS...
  rm -f ops*
  echo $OPS | awk -v RS=, '{print}' > ops.txt
fi
cp -f /tmp/server.properties .
java -jar /tmp/forge-$FORGEVERSION-installer.jar --installServer >/dev/null 2>&1
echo "eula=true" > eula.txt
exec java -Xms512M -Xmx900M -jar /tmp/minecraft_server.$RECOMMENDEDMINE.jar
