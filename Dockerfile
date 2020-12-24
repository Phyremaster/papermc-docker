# JRE base
FROM arm64v8/openjdk:11.0-jre-slim

# Environment variables
ENV MC_VERSION="1.16.4" \
    PAPER_BUILD="latest" \
    MC_RAM="1G" \
    JAVA_OPTS=""

ADD papermc.sh .
RUN apt-get update;
RUN apt-get install -y wget
RUN apt-get install -y jq
RUN rm -rf /var/lib/apt/lists/*
RUN mkdir /papermc

# Start script
CMD ["sh", "./papermc.sh"]

# Container setup
EXPOSE 25565/tcp
EXPOSE 25565/udp
VOLUME /papermc
