# JRE base
FROM alpine:latest

# Environment variables
ENV MC_VERSION="latest" \
    PAPER_BUILD="latest" \
    MC_RAM="1G" \
    JAVA_OPTS=""

ADD papermc.sh .
RUN apk add --no-cache \
        openjdk8-jre-base \
        wget jq \
    && mkdir /papermc

# Start script
CMD ["sh", "./papermc.sh"]

# Container setup
EXPOSE 25565/tcp
EXPOSE 25565/udp
VOLUME /papermc
