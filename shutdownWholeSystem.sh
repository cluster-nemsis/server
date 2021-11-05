#!/bin/bash
# This script is supposed to be executed with sudo

# Check for each node if is alive and try to shut it down
NODES=( SBC1-Beagle SBC2-Beagle SBC3-VIM3 SBC4-OdroidN2 SBC5-JNano SBC6-Coral NFS-Server );
user="chibchohaec"
nfsuser="sshd"
password="chibchohaec-fe02"

for i in ${!NODES[@]}; do
  node=${NODES[$i]};
  echo -n "Checking if $node is alive... ";
  p=$( ping -c 1 $node &> /dev/null );
  if [ $? -eq 0 ]; then
    echo "Yes";
    if [[ "$node" == "NFS-Server" ]]; then
      echo -n "Unmounting NFS in server... ";
      umount /mnt/chibchohaec &> /dev/null;
      if [ $? -eq 0 ]; then
        echo "Ok";
      else
        echo "Error";
      fi;  
      echo -n "Shutting down: $node... "
      sshpass -p "$password" ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" ${nfsuser}@${node} shutdown.sh &> /dev/null &
      echo "OK"
    else
      echo -n "Shutting down: $node... "
      sshpass -p "$password" ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" ${user}@${node} sudo /sbin/shutdown -h now &> /dev/null &
      echo "OK"
    fi;  
  else
    echo "No";
  fi;
done;
