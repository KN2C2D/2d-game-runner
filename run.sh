#! /bin/bash

#$1 ---> team1
#$2 ---> team2
#$3 ---> port
#$4 ---> tag

DIR=`dirname $0`

#running Games
$DIR/teams/$1/startAll $3 &
$DIR/teams/$2/startAll $3 &
rcssserver server::synch_mode=true server::verbose=off server::port=$3

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

mv $DIR/*.rcg "$1-$rt1-vs-$2-$rt2-$D.rcg"
mv $DIR/*.rcl "$1-$rt1-vs-$2-$rt2-$D.rcl"

if ! [ -d $DIR/results ]
then
  mkdir $DIR/results
fi

#tagging
if [ -n $4 ]
then
  if ! [ -d $DIR/results/$4 ]
  then
    mkdir $DIR/results/$4
  fi

  mv $DIR/*.rc? $DIR/results/$4/
else
  mv $DIR/*.rc? $DIR/results/
fi
