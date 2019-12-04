#! /bin/bash

# n : number of games running simultaneously
# tag (optional): Game results will be saved on results/tag
# ssp (optional) : servers start port - first server will be run on
#           this port and the number will be increased for next server and so on
# spd (optional) : servers port difference - the port number will be
#           increased by sdp from each server to the next

# initializing
declare -i n
read -p "enter number of games running simultaneously: " n
read -t 5 -p "enter tag: " tag
if [[ $tag = "" ]]
then
  echo
fi

declare -i ssp
read -t 5 -p "enter servers start port: " ssp
if [ $ssp -eq 0 ]
then
  ssp=6000
  echo "ssp=6000"
fi

declare -i spd
read -t 5 -p "enter servers port difference: " spd
if [ $spd -eq 0 ]
then
  spd=10
  echo "spd=10"
fi

DIR=`dirname $0`
echo "start" $$ >> proc.txt
# running runOnPort script for each set of games (n times)
declare -i i
declare -i port=$ssp
declare -i lim=$n-1
for (( i= 0; i<n; i++))
do
  $DIR/runOnPort.sh $port $n $i $tag &
  port=$port+$spd
done
rm -r $DIR/proc.txt
