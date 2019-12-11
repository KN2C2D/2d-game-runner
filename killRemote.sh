#! /bin/bash

# $1 ---> remote_index: index of remote server (for this script) in remoteAddresses.txt (optional)
# $2 ---> port that want to kill (optional)
################################################################################
DIR=`dirname $0`
################################################################################
findServer(){
  declare -i i=1
  declare -i n=$2
  input=$1
  declare -i wordCount

  server=""
  serverPath=""

  while IFS= read -r line
  do
    if [[ $i -eq $n ]]; then
      wordCount=0

      for word in $line
      do
        tempArr[wordCount]=$word
        wordCount=$wordCount+1
      done

      if [[ $wordCount -eq 3 ]]; then
        server=${tempArr[0]}
        serverPath=${tempArr[2]}
        return 0
      elif [[ $wordCount -eq 2 ]]; then
        server=${tempArr[0]}
        serverPath="Desktop/RemoteGamesFiles"
        return 0
      else
        return 1
      fi
    fi
    i=$i+1
  done < $input

  return 1
}
################################################################################
server_index=$1
if [[ -n $server_index ]]; then
  findServer "$DIR/remoteAddresses.txt" "$server_index"
  echo $server
  echo $serverPath
  if [[ -n $server ]] && [[ ${server:0:1} != "#" ]]; then
    ssh $server "$serverPath/kill.sh" $2 </dev/null
  fi
else
  input="$DIR/remoteAddresses.txt"
  while IFS= read -r line
  do
    wordCount=0

    for word in $line
    do
      tempArr[wordCount]=$word
      wordCount=$wordCount+1
    done

    server=""
    serverPath=""

    if [[ $wordCount -eq 3 ]]; then
      server=${tempArr[0]}
      serverPath=${tempArr[2]}
    elif [[ $wordCount -eq 2 ]]; then
      server=${tempArr[0]}
      serverPath="Desktop/RemoteGamesFiles"
    fi

    if [[ -n $server ]] && [[ ${server:0:1} != "#" ]]; then
      ssh $server "$serverPath/kill.sh" </dev/null
    fi

  done < $input
fi
