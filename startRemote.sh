#! /bin/bash

# input discription
# n : number of games running simultaneously
# ssp (optional) : servers start port - first server will be run on
#           this port and the number will be increased for next server and so on
# spd (optional) : servers port difference - the port number will be
#           increased by sdp from each server to the next

#global variables
declare -i n
declare -i ssp
declare -i spd
teamsDIR=""
resultDIR=""
DIR=`dirname $0`
declare -i lineOfResults
declare -i lineOfGames=`wc -l $DIR/Games.txt | awk '{ print $1 }'`
declare -i firstLines

#methods
initialize() {
  read -t 5 -p "enter path of teams directory: " teamsDIR
  if [[ $teamsDIR = "" ]]; then
    echo "$DIR/teams"
  fi
  ###########
  read -t 5 -p "enter path of results directory: " resultDIR
  if [[ $resultDIR = "" ]]; then
    echo "$DIR/results"
  fi
  ############
  read -t 5 -p "enter servers start port: " ssp
  if [[ $ssp -eq 0 ]]; then
    ssp=6000
    echo "ssp=6000"
  fi
  ###########
  read -t 5 -p "enter servers port difference: " spd
  if [[ $spd -eq 0 ]]; then
    spd=10
    echo "spd=10"
  fi
}

writePathToFile() {
  if [[ $resultDIR = "" ]] ; then
    resultDIR=$DIR/results
  fi
  if [[ $teamsDIR = "" ]] ; then
    teamsDIR=$DIR/teams
  fi

  firstChar=${resultDIR:0:1}

  if [[ $firstChar = "." ]] ; then
    resultDIR=${resultDIR:1}
    resultDIR=`pwd`$resultDIR
  fi
  echo $teamsDIR > $DIR/path.txt
  echo $resultDIR >> $DIR/path.txt
}

countN() {
  input=$1
  declare -i m=0
  declare -i count

  while IFS= read -r line
  do
    count=0

    for word in $line
    do
      W[count]=$word
      count+=1
    done

    if [[ $count -gt 1 ]] && [[ $count -lt 4 ]] && [[ ${W[0]:0:1} != "#" ]]
    then
      m=`expr ${W[1]} + $m`
    fi
  done < $input
  n=$m
}

findLineOfResults() {
  if [ -e $resultDIR/Results.txt ] ; then
    lineOfResults=`wc -l $resultDIR/Results.txt | awk '{ print $1 }'`
  else
    lineOfResults=0
  fi
}

bar() {
  local items=$1
  local total=$2
  local size=$3
  per=$(($items*$size/$total % $size))
  left=$(($size-$per))
  chars=$(local s=$(printf "%${per}s"); echo "${s// /=}")
  echo -ne "[$chars>";
  printf "%${left}s"
  echo -ne ']\r'
}

clearbar() {
  local size=$1
  printf " %s${size}  "
  echo -ne "\r"
}

progressBar() {
  declare -i preLine=-1
  findLineOfResults
  firstLines=$lineOfResults
  lineOfResults=0
  bar 0 100 50
  lineOfGames=`wc -l $DIR/Games.txt | awk '{ print $1 }'`
  while ! [ $lineOfGames -eq $lineOfResults ] ; do
    findLineOfResults
    lineOfResults=$lineOfResults-$firstLines
    lineOfGames=`wc -l $DIR/Games.txt | awk '{ print $1 }'`
    declare -i percent=$lineOfResults
    percent=$percent*100
    percent=$percent/$lineOfGames
    if ! [ $lineOfResults -eq $preLine ] ; then
      echo -n  $percent %
      bar $percent 100 50
    fi
    preLine=$lineOfResults
  done

  echo "[=======================================================>"
  echo "Done!"
}

#main method
main() {
  echo "start" $$ > $DIR/proc.txt

  sed -i -r '/^\s*$/d' $DIR/Games.txt
  initialize
  countN "$DIR/remoteAddresses.txt"
  writePathToFile

  echo ""
  echo "Updating remote servers."
  $DIR/updateRemote.sh
  echo "Remote servers updated."

  # running runOnRemote script for each set of games (n times) (each server and port)
  declare -i m=0
  declare -i lim
  input="$DIR/remoteAddresses.txt"
  declare -i count
  declare -i i
  declare -i port=$ssp
  declare -i remote_index=1

  while IFS= read -r line
  do
    count=0

    for word in $line
    do
      W[count]=$word
      count+=1
    done


    if [[ $count -gt 1 ]] && [[ $count -lt 4 ]] && [[ ${W[0]:0:1} != "#" ]]
    then
      lim=`expr ${W[1]}`
      port=$ssp
      for (( i=0; i < lim; i++ )); do
        $DIR/RemoteSubScritps/runOnRemote.sh $remote_index $port $n $m &
        port=$port+$spd
        m+=1
      done
    fi

    remote_index+=1
  done < $input

  progressBar

  rm $DIR/proc.txt
}

#
main
