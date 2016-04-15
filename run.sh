#!/bin/bash
set -x

echo "*** Starting Server ***"
useradd -c "minecraft user" -u 1000 minecraft
chown -R minecraft:minecraft /srv
su minecraft -c /minecraft.sh
