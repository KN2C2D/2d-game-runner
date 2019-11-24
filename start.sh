#! /bin/bash

DIR=`dirname $0`
input="$DIR/Games.txt"

declare -i idx=0

while IFS= read -r line
do
  idx=`expr index $line "_"`
  t1=${line:0:idx-1}
  t2=${line:idx}
  $DIR/run.sh $t1 $t2
done < $input
