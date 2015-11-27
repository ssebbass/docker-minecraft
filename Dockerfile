# My First DockerFile
# Just trying to get a minecraft server running to play with my son

FROM java:jre

MAINTAINER sSeBBaSs

EXPOSE 25565

COPY minecraft.sh /minecraft.sh
COPY run.sh /run.sh

VOLUME ["/srv"]
COPY server.properties /tmp/server.properties
WORKDIR /srv

RUN chmod +x /minecraft.sh
RUN chmod +x /run.sh
CMD [ "/run.sh" ]
