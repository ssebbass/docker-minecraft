# My First DockerFile
# Just trying to get a minecraft server running to play with my son

FROM java:jre
MAINTAINER sSeBBaSs
EXPOSE 25565

RUN apt-get update && apt-get install -y --no-install-recommends \
  imagemagick \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY minecraft.sh /minecraft.sh
COPY run.sh /run.sh

VOLUME ["/srv"]
COPY server.properties /tmp/server.properties
WORKDIR /srv

RUN chmod +x /minecraft.sh \
  && chmod +x /run.sh

CMD [ "/run.sh" ]
