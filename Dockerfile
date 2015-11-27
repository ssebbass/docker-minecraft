# My First DockerFile
# Just trying to get a minecraft server running to play with my son

FROM java:jre

MAINTAINER sSeBBaSs

EXPOSE 25565

COPY minecraft.sh /minecraft.sh

VOLUME ["/srv"]
COPY server.properties /srv/server.properties
WORKDIR /srv

CMD [ "/minecraft.sh" ]
