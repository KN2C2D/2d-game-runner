#!/bin/bash

# $1 ---> port that want to kill (optional)
port=$1

DIR=`dirname $0`
input="$DIR/proc.txt"

declare -i index=0
###############################methods
initializeArr(){
  index=0
  for var in $line ; do 
 		arr[$index]=$var
 		index=$index+1
  done
}
readFileAndKill(){
  while IFS= read -r line ; do
    echo $line
    initializeArr 
    #arr[0] ---> name of process
    #arr[1] ---> port of process
    #arr[2] ---> pid of process 
    if ! [[ -n $port ]] ; then
  	  kill ${arr[2]}
    else
 	  if [ $port = ${arr[1]} ] ; then 
 	    kill ${arr[2]}
 	  fi
    fi 
  done < $1
} 
###############################

readFileAndKill $input


