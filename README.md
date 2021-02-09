# PaperMC Docker
This is a Linux Docker image for the PaperMC Minecraft server.

PaperMC is an optimized Minecraft server with plugin support (Bukkit, Spigot, Sponge, etc.).
This image provides a basic PaperMC server. All customizations are left to the user.
# Usage
It is assumed that the user has already acquired a working Docker installation. If that is not the case, go do that and come back here when you're done.
## Command
With this image, you can create a new PaperMC Minecraft server with one command (note that running said command indicates agreement to the Minecraft EULA). Here is an example:

```sudo docker run -p 25565:25565 phyremaster/papermc```

While this command will work just fine in many cases, it is only the bare minimum required to start a functional server and can be vastly improved by specifying some...
## Options
There are several command line options that users may want to specify when utilizing this image. These options are listed below with some brief explanation. An example will be provided with each. In the example, the part that the user can change will be surrounded by angle brackets (`< >`). Remember to *remove the angle brackets* before running the command.
- Port
  - This option must be specified. Use port `25565` if you don't know what this is.
  - Set this to the port number that the server will be accessed from.
  - If RCON is to be used, this option must be specified a second time for port `25575`.
  - `-p <12345>:25565`
  - `-p <12345>:25565 -p <6789>:25575`
- Volume
  - Set this to a name for the server's Docker volume (defaults to randomized gibberish).
  - Alternatively, set this to a path to a folder on your computer.
  - `-v <my_volume_name>:/papermc`
  - `-v </path/to/files>:/papermc`
- Detached
  - Include this to make the container independent from the current command line.
  - `-d`
- Terminal/Console
  - Include these flags if you want access to the server's command line via `docker attach`.
  - These flags can be specified separately or as one option.
  - `-t` and `-i` in any order
  - `-ti` or `-it`
- Restart Policy
  - If you include this, the server will automatically restart if it crashes.
  - Stopping the server from its console will still stop the container.
  - It is highly recommended to only stop the server from its console (not via Docker).
  - `--restart on-failure`
- Name
  - Set this to a name for the container (defaults to a couple of random words).
  - `--name "<my-container-name>"`
There is one more command line option, but it is a bit special and deserves its own section.
### Environment Variables
Environment variables are options that are specified in the format `-e <NAME>="<VALUE>"` where `<NAME>` is the name of the environment variable and `<VALUE>` is the value that the environment variable is being set to. This image has four environment variables:
- Minecraft Version
  - **Name:** `MC_VERSION`
  - Set this to the Minecraft version that the server should support.
  - Note: there must be a PaperMC release for the specified version of Minecraft.
  - If this is not set, the latest version supported by PaperMC will be used.
  - Changing this on an existing server will change the version *without wiping the server*.
  - `-e MC_VERSION="<latest>"`
- PaperMC Build
  - **Name:** `PAPER_BUILD`
  - Set this to the number of the PaperMC build that the server should use (**not the Minecraft version**).
  - If this is not set, the latest PaperMC build for the specified `MC_VERSION` will be used.
  - Changing this on an existing server will change the version *without wiping the server*.
  - `-e PAPER_BUILD="<latest>"`
- RAM
  - **Name:** `MC_RAM`
  - Set this to the amount of RAM the server can use.
  - Must be formatted as a number followed by `M` for "Megabytes" or `G` for "Gigabytes".
  - If this is not set, it will use 1 Gigabyte of RAM default.
  - `-e MC_RAM="<4G>"`
- Java options
  - **Name:** `JAVA_OPTS`
  - **ADVANCED USERS ONLY**
  - Set to any additional Java command line options that you would like to include.
  - By default, this environment variable is set to the empty string.
  - `-e JAVA_OPTS="-XX:+UseConcMarkSweepGC -XX:+UseParNewGC"`
## Further Setup
From this point, the server should be configured in the same way as any other Minecraft server. The server's files, including `server.properties`, can be found in the volume that was specified earlier. The port that was specified earlier will probably need to be forwarded as well. For details on how to do this and other such configuration, Google it, because it works the same as any other Minecraft server.
# Technical
This project *does **NOT** redistribute the Minecraft server files*. Instead, the (very small) script that is inside of the image, `papermc.sh`, downloads these files from their official sources during installation.

**PLEASE NOTE:** This is an unofficial project. I did not create PaperMC. [This is the official PaperMC website.](https://papermc.io/)

## Project Pages
- [GitHub page](https://github.com/Phyremaster/papermc-docker).
- [Docker Hub page](https://hub.docker.com/r/phyremaster/papermc).
