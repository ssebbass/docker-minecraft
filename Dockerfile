# My First DockerFile
# Just trying to get a minecraft server running to play with my son

FROM debian-openjdk8

MAINTAINER sSeBBaSs

EXPOSE 25565

COPY minecraft.sh /minecraft.sh

VOLUME ["/srv"]
COPY server.properties /tmp/server.properties
WORKDIR /srv

RUN chmod +x /minecraft.sh
CMD [ "/minecraft.sh" ]
