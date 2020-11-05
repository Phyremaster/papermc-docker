#!/bin/bash

# Enter server directory
mkdir -p papermc
cd papermc

JAR_NAME=papermc-${MC_VERSION}-${PAPER_BUILD}

# Perform initial setup
outdated=false
urlPrefix=https://papermc.io/api/v1/paper/${MC_VERSION}
if [ ${PAPER_BUILD} = latest ]
  then
    outdated= [ "$(wget -q -O- ${urlPrefix}/latest | diff -s latest  -)" != "Files latest and - are identical" ]
fi

if [ ! -e ${JAR_NAME}.jar ] || ${outdated}
  then
    wget ${urlPrefix}/${PAPER_BUILD}/download -O ${JAR_NAME}.jar
    if [ ! -e eula.txt ]
    then
      java -jar ${JAR_NAME}.jar
      sed -i 's/false/true/g' eula.txt
    fi
fi

wget ${urlPrefix}/latest -O latest

# Start server
java -server -Xms${MC_RAM} -Xmx${MC_RAM} ${JAVA_OPTS} -jar ${JAR_NAME}.jar nogui
