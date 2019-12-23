#! /bin/bash

DIR=`dirname $0`
input="$DIR/data/remoteAddresses.txt"
DEFAULT_REMOTE_PATH="Desktop/RemoteGamesFiles"

#main method
main() {
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

    if [ $count -eq 3 ]
    then
      server=${W[0]}
      remotePath=${W[2]}
    elif [ $count -eq 2 ]
    then
      server=${W[0]}
      declare -i idx=`expr index ${W[0]} '@'`
      user=${W[0]:0:idx-1}
      remotePath="/home/$user/$DEFAULT_REMOTE_PATH"
    fi

    if [[ $count -gt 1 ]] && [[ $count -lt 4 ]] && [[ ${server:0:1} != "#" ]]
    then
      ssh $server rm -r $remotePath </dev/null

      echo "$server -> Done."
    fi

  done < $input
}

#
main
