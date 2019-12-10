#! /bin/bash

# n : number of games running simultaneously
# global_tag (optional): Game results will be saved on results/global_tag
# ssp (optional) : servers start port - first server will be run on
#           this port and the number will be increased for next server and so on
# spd (optional) : servers port difference - the port number will be
#           increased by sdp from each server to the next

#############################################variables
declare -i n
declare -i ssp
declare -i spd
global_tag=""
teamsDIR=""
resultDIR=""
##############################################methods
initialize(){
  read -t 5 -p "enter path of teams directory: " teamsDIR
  if [[ $teamsDIR = "" ]] ; then
    echo
  fi
  ###########
  read -t 5 -p "enter path of results directory: " resultDIR
  if [[ $resultDIR = "" ]] ; then
    echo
  fi
  ###########
  read -t 5 -p "enter number of games running simultaneously: " n
  if [ $n -eq 0 ] ; then
    n=1
    echo "n=1"
  fi
  ############
  read -t 5 -p "enter servers start port: " ssp
  if [ $ssp -eq 0 ] ; then
    ssp=6000
    echo "ssp=6000"
  fi
  ###########
  read -t 5 -p "enter servers port difference: " spd
  if [ $spd -eq 0 ] ; then
    spd=10
    echo "spd=10"
  fi
}
writePathToFile(){
  firstChar=${resultDIR:0:1}
  if [[ $firstChar = "." ]] ; then
    resultDIR=${resultDIR:1:${#resultDIR}}
    resultDIR=`pwd`$resultDIR
  fi
  resultDIR=$resultDIR
  echo $teamsDIR > path.txt
  echo $resultDIR >> path.txt
}
###################################################

initialize
writePathToFile

DIR=`dirname $0`
cd $DIR
echo "start" $$ > proc.txt
# running runOnPort script for each set of games (n times)
declare -i i
declare -i port=$ssp
for (( i= 0; i<n; i++)) ; do
  ./runOnPort.sh $port $n $i &
  port=$port+$spd
done
wait
rm -r proc.txt
