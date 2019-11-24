#! /bin/bash

echo $1
echo "VS"
echo $2

DIR="$(dirname $0)"

nickname=$DIR
declare -i i=`expr index $nickname "/*"`

while [ $i -ne 0 ]
do
  echo $nickname
  echo $i
  i=`expr index $nickname "/*"`
  nickname=${nickname:$i}
done

$DIR/teams/$1/startAll &
$DIR/teams/$2/startAll &
rcssserver server::synch_mode=true server::verbose=off

D="$(date +%Y%m%d%H%M%S)"
mv $DIR/*.rcg "$1_vs_$2-$D.rcg"
mv $DIR/*.rcl "$1_vs_$2-$D.rcl"

if ! [ -d $DIR/results ]
then
  mkdir $DIR/results
  mkdir $DIR/results/$nickname
else
  if ! [ -d $DIR/results/$nickname ]
  then
    mkdir $DIR/results/$nickname
  fi
fi

mv $DIR/*.rc? $DIR/results/$nickname
