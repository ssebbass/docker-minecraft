# docker-minecraft
docker minecraft dockerfile

Supported ENV:
> OPS -->  Operators list, OP="OP1,OP2"

Usage:
> docker run -d -p <host>:25565 -v <some dir>:/srv -e OPS="OP1,OP2" ssebbass/docker-minecraft

Example:
> docker run -d -p 25565:25565 -v /srv/minecraftserver:/srv -e OPS="FOO,BAR" ssebbass/docker-minecraft
