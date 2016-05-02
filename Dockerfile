# My First DockerFile
# Just trying to get a minecraft server running to play with my son

FROM java:jre
MAINTAINER sSeBBaSs (ssebbass@gmail.com)
EXPOSE 25565

RUN apt-get update &&\
  apt-get upgrade -y &&\
  apt-get install -y --no-install-recommends imagemagick &&\
  apt-get clean &&\
  rm -rf /var/lib/apt/lists/*

# Set timezone to BA
RUN echo 'America/Argentina/Buenos_Aires' > /etc/timezone && \
  dpkg-reconfigure --frontend noninteractive tzdata

# Minecraft scripts and configs
ADD minecraft.sh /minecraft.sh
ADD run.sh /run.sh
ADD server.properties /tmp/server.properties

VOLUME ["/srv"]
WORKDIR /srv
CMD [ "/run.sh" ]
