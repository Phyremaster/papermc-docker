# JRE base
FROM arm64v8/openjdk:16-slim

# Environment variables
ENV MC_VERSION="latest" \
    PAPER_BUILD="latest" \
    MC_RAM="1G" \
    JAVA_OPTS=""

# Dependencies
ADD papermc.sh .
RUN apt-get update \
    && apt-get install -y wget \
    && apt-get install -y jq \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /papermc

# Start script
CMD ["sh", "./papermc.sh"]

# Container setup
EXPOSE 25565/tcp
EXPOSE 25565/udp
VOLUME /papermc
