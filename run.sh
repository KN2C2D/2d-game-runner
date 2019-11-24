#! /bin/bash

echo $1
echo "VS"
echo $2

DIR=`pwd`

#running Games
$DIR/teams/$1/startAll &
$DIR/teams/$2/startAll &
rcssserver server::synch_mode=true server::verbose=off

#finding date for adding to log files
D="$(date +%Y%m%d%H%M%S)"

#extraction results from from log files to adding to new log files
declare -i i=0
tmp=`ls *.rcg`
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

mv $DIR/*.rc? $DIR/results/
