#!/bin/bash

# Enter server directory
cd papermc

# Set nullstrings back to 'latest'
: ${MC_VERSION:='latest'}
: ${PAPER_BUILD:='latest'}

# Lowercase these to avoid 404 errors on wget
MC_VERSION="${MC_VERSION,,}"
PAPER_BUILD="${PAPER_BUILD,,}"

# Get version information and build download URL and jar name
# New API https://fill.papermc.io/v3/projects/paper/versions/1.21.10/builds/117
URL='https://fill.papermc.io/v3/projects/paper/versions'
if [[ $MC_VERSION == latest ]]
then
  # Get the latest MC version
  if [[ -e papermc.json ]]
  then
      rm papermc.json
  fi
  wget -qO papermc.json "$URL" # "-r" is needed because the output has quotes otherwise

  MC_VERSION=$(jq -r '.versions[0].version.id' papermc.json) # "-r" is needed because the output has quotes otherwise
fi
URL="${URL}/${MC_VERSION}"

if [[ $PAPER_BUILD == latest ]]
then
    # Get the latest build
    PAPER_BUILD=$(jq -r '.versions[0].builds[-1]' papermc.json) # "-r" is needed because the output has quotes otherwise
    #  PAPER_BUILD=$(wget -qO - "$URL" | jq '.builds[-1]')
fi
URL="${URL}/builds/${PAPER_BUILD}"
JAR_NAME="paper-${MC_VERSION}-${PAPER_BUILD}.jar"

if [[ $JAVA_OPTS == "" ]]
then
    JAVA_OPTS=$(jq -r '.versions[0].version.java.flags.recommended' papabermc.json | tr -d '",[]')
fi
DOWNLOAD_URL=$(wget -qO - "$URL" | jq -r '.downloads."server:default".url')

# Update if necessary
if [[ ! -e $JAR_NAME ]]
then
  # Remove old server jar(s)
  rm -f *.jar
  # Download new server jar
  wget "${DOWNLOAD_URL}" -O "${JAR_NAME}"
fi

# Update eula.txt with current setting
echo "eula=${EULA:-false}" > eula.txt

# Add RAM options to Java options if necessary
if [[ -n $MC_RAM ]]
then
  JAVA_OPTS="-Xms${MC_RAM} -Xmx${MC_RAM} $JAVA_OPTS"
fi

# Start server
exec java -server $JAVA_OPTS -jar "$JAR_NAME" nogui
