#! /bin/bash

# run run script for k * n + m games from Games.txt on specifiedn port
# $1 -> Port for the games to be run on
# $2 -> n
# $3 -> m
# $4 -> tag (optional)

declare -i port=$1
declare -i i=0
declare -i n=$2
declare -i m=$3
tag=$4

DIR=`dirname $0`
cd $DIR
input="Games.txt"

declare -i idx
declare -i i=0

while IFS= read -r line
do
  if [ $i -eq $m ]
  then
    idx=`expr index $line "_"`
    t1=${line:0:idx-1}
    t2=${line:idx}
    ./run.sh $t1 $t2 $port $tag
  fi

  i=$i+1
  if [ $i -eq $n ]
  then
    i=0
  fi
done < $input
