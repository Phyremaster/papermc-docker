#!/bin/bash

# Enter server directory
cd papermc

DOCKER_USER='mcdockeruser'
DOCKER_GROUP='mcdockergroup'

# Check User and init
if ! id "$DOCKER_USER" >/dev/null 2>&1; then
    echo "First start of the docker container, start initialization process."

    USER_ID=${PUID:-9001}
    GROUP_ID=${PGID:-9001}
    echo "Starting with $USER_ID:$GROUP_ID (UID:GID)"

    groupadd -f -g $GROUP_ID $DOCKER_GROUP
    useradd --shell /bin/bash -u $USER_ID -g $GROUP_ID -o -c "" -m $DOCKER_USER

    chown -vR $USER_ID:$GROUP_ID /papermc
    chmod -vR ug+rwx /papermc
fi

# Get version information and build download URL and jar name
URL=https://papermc.io/api/v2/projects/paper
if [ ${MC_VERSION} = latest ]
then
  # Get the latest MC version
  MC_VERSION=$(gosu $DOCKER_USER wget -qO - $URL | jq -r '.versions[-1]') # "-r" is needed because the output has quotes otherwise
fi
URL=${URL}/versions/${MC_VERSION}
if [ ${PAPER_BUILD} = latest ]
then
  # Get the latest build
  PAPER_BUILD=$(gosu $DOCKER_USER wget -qO - $URL | jq '.builds[-1]')
fi
JAR_NAME=paper-${MC_VERSION}-${PAPER_BUILD}.jar
URL=${URL}/builds/${PAPER_BUILD}/downloads/${JAR_NAME}

# Update if necessary
if [ ! -e ${JAR_NAME} ]
then
  # Remove old server jar(s)
  rm -f *.jar
  # Download new server jar
  gosu $DOCKER_USER wget ${URL} -O ${JAR_NAME}
fi

# If this is the first run, accept the EULA
if [ ! -e eula.txt ]
then
  # Run the server once to generate eula.txt
  gosu $DOCKER_USER java -jar ${JAR_NAME}
fi

# Edit eula.txt to accept the EULA
gosu $DOCKER_USER sed -i 's/false/true/g' eula.txt

gosu $DOCKER_USER cat eula.txt

# Add RAM options to Java options if necessary
if [ ! -z "${MC_RAM}" ]
then
  JAVA_OPTS="-Xms${MC_RAM} -Xmx${MC_RAM} ${JAVA_OPTS}"
fi

# Start server
exec gosu $DOCKER_USER java -server ${JAVA_OPTS} -jar ${JAR_NAME} nogui
