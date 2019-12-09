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
tag=""
##############################################methods
initialize(){
  read -p "enter number of games running simultaneously: " n
  ############
  read -t 5 -p "enter tag: " tag
  if [[ $tag = "" ]] ; then
    echo
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
runOnPorts(){
  declare -i i
  for (( i= 0; i<n; i++)) ; do
    ./runOnPort.sh $port $n $i $global_tag &
    port=$port+$spd
  done
}
###################################################
DIR=`dirname $0`
cd $DIR

initialize

# $$ -> the process number of the current shell
echo "start" $$ > proc.txt
# running runOnPort script for each set of games (n times)
declare -i port=$ssp
runOnPorts

rm -r proc.txt
