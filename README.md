# docker-minecraft
docker minecraft dockerfile

Supported ENV:
```
OPS         -->   Operators list, OP="OP1,OP2"
SEED        -->   Terrain seed number, SEED=#
MOTD        -->   Server message of the day, MOTD="Some MOTD message"
MAP         -->   Map name, MAP="wold"
CLEANMAP    -->   Cleans $MAP|world on server startup, CLEANMAP=true
GRAVATAR    -->   Gravatar email for server icon, GRAVATAR="email@domain.com"
DIFFICULTY  -->   Set game difficulty, DIFFICULTY=#
EULA        -->   Accept EULA, EULA=true
MODE        -->   Set online mode, MODE=false|true
```

Usage:
```
# docker run -d -p <host>:25565 -v <some dir>:/srv -e OPS="OP1,OP2" ssebbass/docker-minecraft
```

Example:
```
# docker run -d -p 25565:25565 -v /srv/minecraftserver:/srv -e MOTD="My server MOTD" -e SEED="488956386" -e OPS="FOO,BAR" ssebbass/docker-minecraft
```
