# JRE base
FROM openjdk:16-slim

# Environment variables
ENV MC_VERSION="latest" \
    PAPER_BUILD="latest" \
    MC_RAM="" \
    JAVA_OPTS="" \
    CUSTOM_APT_PACKAGES=""

ADD papermc.sh .
RUN apt-get update \
    && apt-get install -y printf \
    && apt-get install -y wget jq $(printf "%s " "${CUSTOM_APT_PACKAGES[@]}") \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /papermc

# Start script
CMD ["sh", "./papermc.sh"]

# Container setup
EXPOSE 25565/tcp
EXPOSE 25565/udp
VOLUME /papermc
