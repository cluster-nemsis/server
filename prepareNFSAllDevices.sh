#!/bin/bash
# This script is supposed to be executed with sudo

# Check for each node if is alive and try to shut it down
node=NFS-Server;
user=sshd;
password="chibchohaec-fe02"
nfs_origin=${node}:/nfs/chibchohaec
nfs_destination=/mnt/chibchohaec

echo -n "Fixing NFS in NAS... ";
p=$( ping -c 1 $node &> /dev/null );
if [ $? -eq 0 ]; then
  umount ${nfs_destination} &> /dev/null
  sshpass -p $password ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" ${user}@${node} /usr/local/config/nfs_user_fix
  echo "Ok";
  sleep 1
  echo -n "Trying to mount NFS on server... "; 
  mount ${nfs_origin} ${nfs_destination} &> /dev/null &
  if [ $? -eq 0 ]; then
    echo "Ok";
    echo;
    echo "Trying to mount NFS on SBCs"; 
    ./mountNFSInAllSBCs.sh 
  else
    echo "Error";
  fi;  
else
  echo "NAS not active!";
fi;
