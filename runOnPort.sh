#! /bin/bash

# run run script for k * n + m games from Games.txt on specifiedn port
#######################################input
# $1 -> Port for the games to be run on
# $2 -> n
# $3 -> m
######################################variables
declare -i port=$1
declare -i i=0
declare -i n=$2
declare -i m=$3
declare -i idx=0
declare -i flag
DIR=`dirname $0`
#########################################methods
initialize_Arr(){
  for word in $line ; do
    Arr[$idx]=$word
    idx=$idx+1
  done
}
readFileAndRun(){
  while IFS= read -r line ; do
    if [ $i -eq $m ] ; then
      idx=0
      initialize_Arr
      if [ $idx -eq 2 ] ; then
        tag=""
        flag=0
      elif [ $idx -eq 3 ] ; then
        tag=${Arr[2]}
        flag=0
      else
        flag=1
      fi
      t1=${Arr[0]}
      t2=${Arr[1]}
      if [ $flag -eq 0 ] ; then
        $DIR/run.sh $t1 $t2 $port $tag 
      fi
    fi

    i=$i+1
    if [ $i -eq $n ] ; then
      i=0
    fi
  done < $1
}

#########################################

#$$ : the process number of the current shell
echo "runOnPort" $port $$ >> $DIR/proc.txt
input="$DIR/Games.txt"
readFileAndRun $input
