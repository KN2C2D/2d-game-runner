#! /bin/bash

# runs run script for k * n + m games from Games.txt on specifiedn port

#input discription
# $1 -> Port for the games to be run on
# $2 -> n
# $3 -> m

#global variables
declare -i port=$1
declare -i i=0
declare -i n=$2
declare -i m=$3
declare -i idx=0
declare -i flag
DIR=`dirname $0`
PARENT_DIR=`dirname $DIR`

##methods
initialize_Arr() {
  for word in $line ; do
    Arr[$idx]=$word
    idx=$idx+1
  done
}

readFileAndRun() {
  declare -i lineCount=0
  declare -i lineIdx=1
  while [[ `wc -l $1 | awk '{ print $1 }'` -gt $lineCount ]] ; do
    if [[ $i -eq $m ]] ; then
      tmp=`head -n $lineIdx $1`
      line=`echo "$tmp" | tail -n 1`
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
    lineCount=lineCount+1
    lineIdx=lineIdx+1
  done
}

#main method
main() {
  #$$ : the process number of the current shell
  echo "runOnPort" $port $$ >> $PARENT_DIR/proc.txt
  input="$PARENT_DIR/data/Games.txt"
  readFileAndRun $input
}

#
main
