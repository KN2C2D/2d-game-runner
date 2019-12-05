#! /bin/bash

# run run script for k * n + m games from Games.txt on specifiedn port
# $1 -> Port for the games to be run on
# $2 -> n
# $3 -> m
# $4 -> tag (optional)


#####################variables
declare -i port=$1
declare -i n=$2
declare -i m=$3
tag=$4
declare -i i=0        
DIR=`dirname $0`
input="$DIR/Games.txt"  #the file include list of games
team1=""
team2=""
#####################


#$$ : the process number of the current shell
echo "runOnPort" $port $$ >> proc.txt


findNameOfTeams(){
  declare -i idx
  idx=`expr index $line "_"`
  team1=${line:0:idx-1}
  team2=${line:idx}
}

readFileAndRun(){
  while IFS= read -r line
  do
    if [ $i -eq $m ]
    then
      findNameOfTeams
      $DIR/run.sh $team1 $team2 $port $tag
    fi
    i=$i+1s
    if [ $i -eq $n ]
    then
      i=0
    fi
  done < $input
}


readFileAndRun
