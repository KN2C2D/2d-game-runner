#! /bin/bash

#$1 ---> team1
#$2 ---> team2
#$3 ---> port
#$4 ---> tag

DIR=`dirname $0`

declare -i port=$3
declare -i coach_port=$3+1
declare -i olcoach_port=$3+2
tag=$4
Team1=$1
Team2=$2

#running Games

$DIR/teams/$Team1/startAll $port &
$DIR/teams/$Team2/startAll $port &
rcssserver server::synch_mode=true server::verbose=off server::port=$port \
server::coach_port=$coach_port server::olcoach_port=$olcoach_port

#finding date for adding to log files
D="$(date +%Y%m%d%H%M%S)"

#extracting results from log files to adding to new log files
declare -i i=0
tmp=`ls $DIR/*.rcg`
i=`expr index $tmp "_"`
tmp=${tmp:$i}
i=`expr index $tmp "-vs"`
rt1=${tmp:0:i-1}
tmp=${tmp:i+3}
i=`expr index $tmp "_"`
tmp=${tmp:i}
i=`expr index $tmp "."`
rt2=${tmp:0:i-1}

logName="$Team1-$rt1-vs-$Team2-$rt2-$D"

mv $DIR/*.rcg "$logName.rcg"
mv $DIR/*.rcl "$logName.rcl"

if ! [ -d $DIR/results ]
then
  mkdir $DIR/results
fi

#tagging
if [ -n $tag ]
then
  if ! [ -d $DIR/results/$tag ]
  then
    mkdir $DIR/results/$tag
  fi

  mv $DIR/$logName.rc? $DIR/results/$tag/
else
  mv $DIR/$logName.rc? $DIR/results/
fi
