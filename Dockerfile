# JRE base
FROM openjdk:16-slim

# Environment variables
ENV MC_VERSION="latest" \
    PAPER_BUILD="latest" \
    MC_RAM="" \
    JAVA_OPTS="" \
    PGID="" \
    PUID="" \
    TMUX_SESSION="server_console"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        wget        `# Allows web downloads` \
        jq          `# Allows for parsing JSON to get the latest MC_VERSION and PAPER_BUILD` \
        bash        `# Ensure bash is installed for the entrypoint.sh script` \
        gosu        `# Allows stepping down from root to PUID:PGID if given` \
        tmux        `# Allows for attaching to server console even when this docker container is part of an orchestration` \
    && apt-get -y autoremove \
    && apt-get clean autoclean \
    && rm -rf /var/lib/apt/lists/*

# Container setup
EXPOSE 25565/tcp
EXPOSE 25565/udp
VOLUME /papermc
WORKDIR /papermc
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY papermc.sh /usr/local/bin/papermc.sh
COPY tmux.conf /etc/tmux.conf

# User resolution order:
# 1. If run with 'docker run --user', the server is run as that user.
# 2. Otherwise, if $PUID and/or $PGID are given, the server is run as $PUID:$PGID.
# 3. Otherwise, the server is run as root.
USER ${PUID:-0}:${PGID:-0}
ENTRYPOINT ["bash", "entrypoint.sh"]

CMD ["bash", "papermc.sh"]
