#! /bin/bash

DIR=`dirname $0`
input="$DIR/remoteAddresses.txt"

DEFAULT_TMP_PATH="Desktop/tmpNetworkTest"

declare -i count
declare -i runFlag

while IFS= read -r line
do
  count=0
  for word in $line
  do
    W[count]=$word
    count+=1
  done

  if [ $count -eq 2 ]
  then
    server=${W[0]}
    tmpPath=${W[1]}
  elif [ $count -eq 1 ]
  then
    server=${W[0]}
    declare -i idx=`expr index ${W[0]} '@'`
    user=${W[0]:0:idx-1}
    tmpPath="/home/$user/$DEFAULT_TMP_PATH"
  fi

  if ! [ $count -eq 0 ]
  then
    ssh $server mkdir -p $tmpPath &
    sleep 0.05
    scp -rC $DIR/[!.]* "$server:$tmpPath" >/tmp/tmp_scp_log.txt &
  fi

  echo $line
done < $input

wait
