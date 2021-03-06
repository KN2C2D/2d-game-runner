#! /bin/bash

#input discription
# run script for k * n + m games from Games.txt on specified port and server
# $1 -> remote_index: index of remote server (for this script) in remoteAddresses.txt
# $2 -> Port for the games to be run on
# $3 -> n: (total number of servers * total number of ports)
# $4 -> m

#storing PID
#$$ : the process number of the current shell
echo "runOnPort" $port $$ >> proc.txt

#variables
DIR=`dirname $0`
PARENT_DIR=`dirname $DIR`

declare -i remote_index=$1
declare -i port=$2
declare -i i=0
declare -i n=$3
declare -i m=$4
declare -i idx=0
declare -i flag

#methods
initialize_Arr() {
  for word in $line
    do
      Arr[$idx]=$word
      idx=$idx+1
    done
}

readFileAndRun() {
  input=$1

  declare -i lineCount=0
  declare -i lineIdx=1
  while [[ `wc -l $1 | awk '{ print $1 }'` -gt $lineCount ]] ; do
    if [[ $i -eq $m ]] ; then
      tmp=`head -n $lineIdx $1`
      line=`echo "$tmp" | tail -n 1`
      idx=0
      initialize_Arr
      if [ $idx -eq 2 ]
      then
        t1=${Arr[0]}
        t2=${Arr[1]}
        tag=""
        flag=0
      elif [ $idx -eq 3 ]
      then
        t1=${Arr[0]}
        t2=${Arr[1]}
        tag=${Arr[2]}
        flag=0
      else
        flag=1
      fi

      if [[ $flag -eq 0 ]] && [[ -n $server ]] && [[ ${server:0:1} != "#" ]]; then
        ssh $server "$serverPath/remoteRun.sh" $t1 $t2 $port $tag </dev/null
      fi
    fi

    i=$i+1
    if [ $i -eq $n ]
    then
      i=0
    fi
    lineCount=lineCount+1
    lineIdx=lineIdx+1
  done
}

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

#main method
main() {
  #finding the specified server
  findServer "$PARENT_DIR/data/remoteAddresses.txt" "$remote_index"

  readFileAndRun "$PARENT_DIR/data/Games.txt"
}

#
main
