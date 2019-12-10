#! /bin/bash
set -o errexit
DIR=`dirname $0`
input="$DIR/remoteAddresses.txt"

DEFAULT_REMOTE_PATH="Desktop/RemoteGamesFiles"

declare -i count
declare -i runFlag

echo "Compressing teams folder."
tar -czf $DIR/teams.tar.gz $DIR/teams
echo "teams folder compressed."

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
    remotePath=${W[1]}
  elif [ $count -eq 1 ]
  then
    server=${W[0]}
    declare -i idx=`expr index ${W[0]} '@'`
    user=${W[0]:0:idx-1}
    remotePath="/home/$user/$DEFAULT_REMOTE_PATH"
  fi

  if ! [ $count -eq 0 ]
  then
    ssh $server mkdir -p $remotePath </dev/null
    scp -rC $DIR/teams.tar.gz "$server:$remotePath" >/tmp/tmp_scp_log.txt </dev/null
    ssh $server tar -xzf $remotePath/teams.tar.gz -C $remotePath/ </dev/null
    ssh $server rm $remotePath/teams.tar.gz </dev/null
  fi

  echo "$line -> Done."
done < $input

wait

rm $DIR/teams.tar.gz
