# JRE base
FROM openjdk:16-slim

# Environment variables
ENV MC_VERSION="latest" \
    PAPER_BUILD="latest" \
    MC_RAM="" \
    JAVA_OPTS="" \
    ALLOW_NFS=""

ADD papermc.sh .
RUN apt-get update \
    && apt-get install -y wget \
    && apt-get install -y jq
    # Install nfs-common when ALLOW_NFS is set
    && { test "$ALLOW_NFS" && apt-get install -y nfs-common; true; } \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /papermc

# Start script
CMD ["sh", "./papermc.sh"]

# Container setup
EXPOSE 25565/tcp
EXPOSE 25565/udp
VOLUME /papermc
