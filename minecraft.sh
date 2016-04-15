#!/bin/bash
set -xe

if [ -n "$VERSION" ]; then
	cd /tmp
  if [ ! -f "minecraft_server.$VERSION.jar" ]; then
  	wget "https://s3.amazonaws.com/Minecraft.Download/versions/$VERSION/minecraft_server.$VERSION.jar"
  else
    echo "Already have the minecraft_server."$VERSION".jar"
  fi
else
	echo "Please: -e VERSION=\"1.9\""
	exit 1
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
  echo Downloading Gravatar...
  wget -O server-icon.jpg http://www.gravatar.com/avatar/$URL?s=64 2>/dev/null
  convert server-icon.jpg server-icon.png
fi

# Difficulty conf
if [ -n "$DIFFICULTY" ]; then
  echo DIFFICULTY=$DIFFICULTY...
  echo "difficulty=$DIFFICULTY" >> server.properties
else
  echo "difficulty=1" >> server.properties
fi

# Accept EULA
if [ "$EULA" = "true" ]; then
  echo "EULA=$EULA..."
  echo "eula=true" > eula.txt
else
  echo "EULA not accepted..."
fi

# Online Mode conf
if [ "$MODE" = "false" ]; then
  echo "MODE=$MODE..."
  echo "online-mode=false" >> server.properties
else
  echo "MODE=true..."
  echo "online-mode=true" >> server.properties
fi

# Some cleanup
echo "Cleaning old log files"
find /srv -type f -name "*log.gz" -ctime +7 -exec rm -fv {} \+

echo Running minecraft_server.$RECOMMENDEDMINE.jar...
java -Xms512M -Xmx900M -jar /tmp/minecraft_server."$VERSION".jar

