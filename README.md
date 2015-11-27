# docker-minecraft
docker minecraft dockerfile

Supported ENV:
```
OPS   -->   Operators list, OP="OP1,OP2"
SEED  -->   Terrain seed number, SEED=#
MTOD  -->   Server MTOD, MTOD="Some MTOD message"
MAP   -->   Map name, MAP="wold"
CLEANMAP  --> Cleans $MAP|world on server startup, CLEANMAP=true
```

Usage:
```
# docker run -d -p <host>:25565 -v <some dir>:/srv -e OPS="OP1,OP2" ssebbass/docker-minecraft
```

Example:
```
# docker run -d -p 25565:25565 -v /srv/minecraftserver:/srv -e MTOD="My server MTOD" -e SEED="488956386" -e OPS="FOO,BAR" ssebbass/docker-minecraft
```
