# JRE base
FROM amazoncorretto:19.0.1

# Place script at root
WORKDIR /

# Container setup
EXPOSE 25565/tcp
EXPOSE 25565/udp
VOLUME /papermc

# Environment variables
ENV MC_VERSION="latest" \
    PAPER_BUILD="latest" \
    MC_RAM="" \
    JAVA_OPTS=""

COPY papermc.sh .
RUN apt-get update \
    && apt-get install --no-install-recommends -y wget jq\
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /papermc

# Start script
CMD ["sh", "./papermc.sh"]