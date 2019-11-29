#!/bin/bash

# $1 ---> port that want to kill (optional)

port=$1

DIR=`dirname $0`
input="$DIR/proc.txt"

declare -i index

index=0


declare -i idx=0

while IFS= read -r line
do
  echo $line
  for var in $line
  do 
 		arr[$index]=$var
 		index=$index+1
  done
 	index=0
 	#arr[0] ---> name of process
 	#arr[1] ---> port of process
 	#arr[2] ---> pid of process 
 	if ! [ -n $port ]
 	then
 		kill ${arr[2]}
 	else
 		if [ $port = ${arr[1]} ]
 		then 
 			kill ${arr[2]}
 		fi
	fi 
done < $input

