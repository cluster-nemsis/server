#!/bin/bash
# This script is supposed to be executed with sudo

# Check for each node if is alive and try to shut it down
node=NFS-Server;
user=sshd;
password='chibchohaec-fe02' 

echo -n "Shutting down the NAS... ";
p=$( ping -c 1 $node &> /dev/null );
if [ $? -eq 0 ]; then
  umount /mnt/chibchohaec &> /dev/null
  sshpass -p "$password" ssh ${user}@${node} shutdown.sh &
  echo "CMD Sent"; 
else
  echo "Not active!";
fi;
