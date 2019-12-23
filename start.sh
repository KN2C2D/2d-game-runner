#! /bin/bash

#signature
signature='
$$\   $$\ $$\   $$\  $$$$$$\   $$$$$$\
$$ | $$  |$$$\  $$ |$$  __$$\ $$  __$$\
$$ |$$  / $$$$\ $$ |\__/  $$ |$$ /  \__|
$$$$$  /  $$ $$\$$ | $$$$$$  |$$ |
$$  $$<   $$ \$$$$ |$$  ____/ $$ |
$$ |\$$\  $$ |\$$$ |$$ |      $$ |  $$\
$$ | \$$\ $$ | \$$ |$$$$$$$$\ \$$$$$$  |
\__|  \__|\__|  \__|\________| \______/


----------------------------------------
          ***HELIOS_based***
----------------------------------------
by :
    a.sadreddin
    a.sadraii
    m.moazen
    m.teimouri
----------------------------------------
'

# input discription
# n : number of games running simultaneously
# global_tag (optional): Game results will be saved on results/global_tag
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
declare -i lineOfGames=`wc -l $DIR/data/Games.txt | awk '{ print $1 }'`
declare -i firstLines

#methods
initialize() {
  read -t 10 -p "enter path of teams directory: " teamsDIR
  if [[ $teamsDIR = "" ]] ; then
    echo "$DIR/teams"
  fi

  read -t 10 -p "enter path of results directory: " resultDIR
  if [[ $resultDIR = "" ]] ; then
    echo "$DIR/results"
  fi

  read -t 5 -p "enter number of games running simultaneously: " n
  if [ $n -eq 0 ] ; then
    n=1
    echo "n=1"
  fi

  read -t 5 -p "enter servers start port: " ssp
  if [[ $ssp -eq 0 ]]; then
    ssp=6000
    echo "ssp=6000"
  fi

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
  echo $teamsDIR > $DIR/data/path.txt
  echo $resultDIR >> $DIR/data/path.txt
}

runOnPorts() {
  declare -i i
  for (( i= 0; i<n; i++)) ; do
    $DIR/LocalSubScripts/runOnPort.sh $port $n $i &
    port=$port+$spd
  done
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
  lineOfGames=`wc -l $DIR/data/Games.txt | awk '{ print $1 }'`
  while ! [ $lineOfGames -eq $lineOfResults ] ; do
    findLineOfResults
    lineOfResults=$lineOfResults-$firstLines
    lineOfGames=`wc -l $DIR/data/Games.txt | awk '{ print $1 }'`
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
  echo "$signature"
  sed -i -r '/^\s*$/d' $DIR/data/Games.txt
  initialize
  writePathToFile

  # $$ -> the process number of the current shell
  echo "start" $$ > $DIR/proc.txt
  # running runOnPort script for each set of games (n times)
  declare -i port=$ssp
  runOnPorts

  progressBar

  rm $DIR/proc.txt
}

#
main
