#!/bin/bash

DIR=`dirname $0`
input="$DIR/proc.txt"

declare -i index

index=0

DIR=`dirname $0`
input="$DIR/proc.txt"

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
 	if [ ${arr[0]} = "server" ]
 	then
 		kill ${arr[2]}
 	fi
 	if [ ${arr[0]} = "runOnPort" ]
 	then 
 		kill ${arr[2]}
 	fi
 
done < $input
rm -r $DIR/proc.txt
