#! /bin/bash

DIR=`dirname $0`
input="$DIR/remoteAddresses.txt"

TMP_PATH="Desktop/tmpNetworkTest"

while IFS= read -r line
do
  if [ -n $line ]
  then
    idx=`expr index $line '@'`
    user=${line:0:idx-1}
    P="/home/$user/$TMP_PATH"
    ssh $line mkdir -p $P &
    scp -rC $DIR/[!.]* "$line:$P" &
    echo $line
    echo $user
    echo $P
  fi
done < $input

wait

while IFS= read -r line
do
  if [ -n $line ]
  then
    idx=`expr index $line '@'`
    user=${line:0:idx-1}
    P="/home/$user/$TMP_PATH"
    ssh $line $P/runOnPort.sh 6000 2 0 &
    ssh $line $P/runOnPort.sh 6010 2 1 &
    echo $line
    echo $user
    echo $P
  fi
done < $input
