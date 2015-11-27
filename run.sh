#!/bin/bash
set -xe

useradd -c "minecraft user" -u 1000 minecraft
su minecraft -c /minecraft.sh
