# JRE base
FROM openjdk:11.0-jre-slim

# Environment variables
ENV MC_VERSION="1.16.3" \
    PAPER_BUILD="latest" \
    MC_RAM="1G" \
    JAVA_OPTS=""

ADD papermc.sh .
RUN apt-get update \
    && apt-get install -y wget \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /papermc \
    && wget https://papermc.io/api/v1/paper/${MC_VERSION}/latest -O /papermc/latest

# Start script
CMD ["sh", "./papermc.sh"]

# Container setup
EXPOSE 25565/tcp
EXPOSE 25565/udp
VOLUME /papermc
