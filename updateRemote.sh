#! /bin/bash

#Global Variables
DIR=`dirname $0`
input="$DIR/remoteAddresses.txt"

DEFAULT_REMOTE_PATH="Desktop/RemoteGamesFiles"
REMOTE_SCRIPTS_PATH="$DIR/RemoteSubScritps"
TEAMS_PATH=`head -n 1 $DIR/path.txt`

declare -i count
declare -i runFlag

#methods
compress() {
  #compressing and packaging all the files for faster transmit
  echo "Compressing files."
  tar -czf $DIR/transfer.tar.gz $TEAMS_PATH $REMOTE_SCRIPTS_PATH/remoteRun.sh\
   $DIR/path.txt $DIR/masterAddress.txt $DIR/$REMOTE_SCRIPTS_PATH/kill.sh\
   $DIR/$REMOTE_SCRIPTS_PATH/killall.sh
  echo "Files compressed."
}

update() {
  #reading remote server addresses and copying and then extracting the package
  #created above and then putting files in the right order
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
      ssh $server mkdir -p $remotePath </dev/null
      scp -rC $DIR/transfer.tar.gz "$server:$remotePath" >/tmp/tmp_scp_log.txt </dev/null
      ssh $server tar -xzf $remotePath/transfer.tar.gz -C $remotePath/ </dev/null
      ssh $server mv $remotePath/RemoteSubScritps/* $remotePath/ </dev/null
      ssh $server rm -r $remotePath/RemoteSubScritps </dev/null
      ssh $server rm $remotePath/transfer.tar.gz </dev/null

      echo "$server -> Done."
    fi

  done < $input

  wait
}

#main method
main() {
    compress
    update

    #removing the package created above
    rm $DIR/transfer.tar.gz
}

#
main
