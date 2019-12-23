#! /bin/bash

# input discription
# $1 ---> remote_index: index of remote server (for this script) in remoteAddresses.txt (optional)
# $2 ---> port that want to kill (optional)

DIR=`dirname $0`

#methods
findServer() {
  #gets remoteAddresses path and an index as input
  #finds the specified server (specification with input index)
  #return 0 if succesful 1 if failed
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

killall() {
  input=$1

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
}

initializeArr() {
  declare -i idx=0

  for var in $line ; do
 		arr[$index]=$var
 		index=$index+1
  done
}

readFileAndKill() {
  input=$1
  port=$2

  while IFS= read -r line; do
    initializeArr
    #arr[0] ---> name of process
    #arr[1] ---> port of process
    #arr[2] ---> pid of process
    #except start
    if ! [[ -n $port ]]; then
      if [[ ${arr[0]} = "start" ]] ; then
        kill ${arr[1]}
      else
  	kill ${arr[2]}
      fi
    elif [[ $port = ${arr[1]} ]] && [[ ${arr[0]} = "server" ]]; then
      echo ${arr[1]} > $DIR/killed.txt
 	    kill ${arr[2]}
    fi
  done < $input
}

#main method
main() {
  server_index=$1
  port=$2
  if [[ -n $server_index ]]; then
    findServer "$DIR/remoteAddresses.txt" "$server_index"
    if ! [[ -n $port ]] ; then
      echo "you must enter the port!"
    elif [[ -n $server ]] && [[ ${server:0:1} != "#" ]]; then
      ssh $server "$serverPath/kill.sh" $port </dev/null
    fi
  else
    #Local processes kill
    readFileAndKill "$DIR/proc.txt" $port

    killall "$DIR/remoteAddresses.txt"
  fi
}

#
main $1 $2
