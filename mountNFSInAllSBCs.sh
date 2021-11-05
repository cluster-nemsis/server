#!/bin/bash
# This script is supposed to be executed with sudo
# Be aware that the commands to be executed in the SBC must be enable with sudo to avoid
# asking for passwords: sudoers --> chibchohaec   ALL=NOPASSWD:/bin/mount,/bin/umount,/sbin/shutdown

# Check for each node if is alive and try to shut it down
NODES=( SBC1-Beagle SBC2-Beagle SBC3-VIM3 SBC4-OdroidN2 SBC5-JNano SBC6-Coral );
user="chibchohaec"
password="chibchohaec-fe02"
origin="nfs-server:/nfs/chibchohaec"
dest="/mnt/chibchohaec"

for i in ${!NODES[@]}; do
  node=${NODES[$i]};
  echo -n "Checking if $node is alive... ";
  p=$( ping -c 1 $node &> /dev/null );
  if [ $? -eq 0 ]; then
    echo "Yes";
    echo -n "Mounting NFS on $node... ";
    sshpass -p "$password" ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" ${user}@${node} sudo /bin/mount ${origin} ${dest}  &> /dev/null;
    echo "OK";
  else
    echo "No";
  fi;
done;
