#! /bin/bash

DIR=`dirname $0`
input="$DIR/Games.txt"

declare -i idx=0

while IFS= read -r line
do
  echo "$idx --- $line"
  idx=idx+1
done < $input
