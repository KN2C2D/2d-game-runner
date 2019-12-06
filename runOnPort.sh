#! /bin/bash

# run run script for k * n + m games from Games.txt on specifiedn port
# $1 -> Port for the games to be run on
# $2 -> n
# $3 -> m
# $4 -> global_tag (optional)

declare -i port=$1
declare -i i=0
declare -i n=$2
declare -i m=$3
global_tag=$4

echo "runOnPort" $port $$ >> proc.txt

DIR=`dirname $0`
cd $DIR
input="Games.txt"

declare -i idx=0
declare -i flag

while IFS= read -r line
do
  if [ $i -eq $m ]
  then
    idx=0
    for word in $line
    do
      A[$idx]=$word
      idx=$idx+1
    done

    if [ $idx -eq 2 ]
    then
      t1=${A[0]}
      t2=${A[1]}
      tag=""
      flag=0
    elif [ $idx -eq 3 ]
    then
      t1=${A[0]}
      t2=${A[1]}
      tag=${A[2]}
      flag=0
    else
      flag=1
    fi

    if [ $flag -eq 0 ]
    then
      ./run.sh $t1 $t2 $port $global_tag $tag
    fi
  fi

  i=$i+1
  if [ $i -eq $n ]
  then
    i=0
  fi
done < $input
