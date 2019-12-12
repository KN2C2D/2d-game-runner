#! /bin/bash

# n : number of games running simultaneously
# ssp (optional) : servers start port - first server will be run on
#           this port and the number will be increased for next server and so on
# spd (optional) : servers port difference - the port number will be
#           increased by sdp from each server to the next

#######################################################################variables
declare -i n
declare -i ssp
declare -i spd
teamsDIR=""
resultDIR=""
#########################################################################methods
initialize(){
  read -t 5 -p "enter path of teams directory: " teamsDIR
  if [[ $teamsDIR = "" ]]; then
    echo
  fi
  ###########
  read -t 5 -p "enter path of results directory: " resultDIR
  if [[ $resultDIR = "" ]]; then
    echo
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

writePathToFile(){
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

countN(){
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
################################################################################

DIR=`dirname $0`

echo "start" $$ > $DIR/proc.txt

initialize
countN "$DIR/remoteAddresses.txt"
writePathToFile
$DIR/updateRemote.sh

# running runOnPort script for each set of games (n times)
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

wait

rm $DIR/proc.txt
rm $DIR/path.txt
