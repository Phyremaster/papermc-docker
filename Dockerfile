# JRE base
FROM openjdk:16-slim

# Environment variables
ENV MC_VERSION="latest" \
    PAPER_BUILD="latest" \
    MC_RAM="" \
    JAVA_OPTS=""

ADD papermc.sh .
RUN apt-get update \
    && apt-get install -y wget \
    && apt-get install -y jq \
    && apt-get install -y gosu \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /papermc

# verify that gosu works
RUN gosu nobody true

# Start script
CMD ["sh", "./papermc.sh"]

# Container setup
EXPOSE 25565/tcp
EXPOSE 25565/udp
VOLUME /papermc
