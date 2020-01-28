# Debian base
FROM debian:latest

# Environment variables
ENV MC_VERSION="1.15.2"
ENV PAPER_BUILD="latest"
ENV MC_RAM="1G"
ENV JAVA_OPTS=""

# Java setup
RUN apt-get update
RUN apt-get install -y --allow-unauthenticated default-jdk

# PaperMC setup
RUN apt-get install -y --allow-unauthenticated wget
ADD papermc.sh .
RUN chmod +x papermc.sh

# Start script
CMD ./papermc.sh

# Container setup
EXPOSE 25565/tcp
EXPOSE 25565/udp
VOLUME /papermc
