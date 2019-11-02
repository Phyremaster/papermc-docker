# Debian base
FROM debian:latest

# Environment variables
ENV MC_VERSION="1.14.4"
ENV PAPER_BUILD="latest"
ENV MC_RAM="1G"

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
