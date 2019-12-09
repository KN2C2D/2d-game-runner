#! /bin/bash

DIR=`dirname $0`
input="$DIR/remoteAddresses.txt"

DEFAULT_TMP_PATH="Desktop/tmpNetworkTest"

declare -i idx

while IFS= read -r line
do
  if [ -n $line ]
  then
    idx=`expr index $line '@'`
    user=${line:0:idx-1}
    P="/home/$user/$DEFAULT_TMP_PATH"
    ssh $line mkdir -p $P &
    scp -rC $DIR/[!.]* "$line:$P" >"/tmp/tmpSCPLOG.txt" &
    echo $line
    echo $user
    echo $P
  fi
done < $input

wait
