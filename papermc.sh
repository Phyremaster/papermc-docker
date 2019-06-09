#!/bin/bash

# Enter server directory
mkdir papermc
cd papermc

# Preform initial setup
if [ ! -e papermc-${MC_VERSION}.jar ]
  then
    wget https://papermc.io/api/v1/paper/${MC_VERSION}/latest/download -O papermc-${MC_VERSION}.jar
	if [ ! -e eula.txt ]
	  then
	    java -jar papermc-${MC_VERSION}.jar
		sed -i 's/false/true/g' eula.txt
	fi
fi

# Start server
java -Xms${MC_RAM} -Xmx${MC_RAM} -jar papermc-${MC_VERSION}.jar nogui