#!/bin/bash
# entrypoint.sh
# Run the server in a tmux session as the USER defined in the Dockerfile

set -e

docker_uid=$(id -u)
docker_gid=$(id -g)

echo "Docker USER id: $docker_uid"
echo "Docker PUID environment variable: $PUID"

echo "Docker USER group: $docker_gid"
echo "Docker PGID envenvrionment variable: $PGID"

# Command to run
cmd="$@"

if [[
    # User is root.
    "$docker_uid" == '0' && "$docker_gid" == '0'
    # And PUID and/or GUID are given as enironment variables. This check allows running as root by omitting these variables.
    && -n "${PUID}${PGID}"
 ]]; then
  # Find group name if it exists
  group_name=$(getent group $PGID | cut -d":" -f1)
  if [ -z $group_name ]; then
    # Group doesn't exist, create it
    group_name="papermc-group"
    groupadd -rg $PGID $group_name
  fi
  # Find user name if it exists
  user_name=$(getent passwd $PUID | cut -d":" -f1)
  if [ -z $user_name ]; then
    # User doesn't exist, create it
    user_name="papermc-user"
    useradd -ru $PUID $user_name
  fi
  # Add user to group
  usermod -g $group_name $user_name
  
  # Change command so that it is run by the non-root user
  cmd="gosu $user_name $cmd"
fi

# Run command in tmux session.
exec tmux -f /etc/tmux.conf new -As "$TMUX_SESSION" "$cmd"
