#! /bin/bash

#$1 ---> team1
#$2 ---> team2
#$3 ---> port
#$4 ---> tag
################################################################################
DIR=`dirname $0`

declare -i port=$3
declare -i coach_port=$3+1
declare -i olcoach_port=$3+2

tag=$4

Team1=$1
Team2=$2
#finding date for adding to log files
D="$(date +%Y%m%d%H%M%S)"
tmpDirName="$Team1-$Team2"
rt1=""
rt2=""
################################################################################
runServerAndAgents(){
  #running Games
  $DIR/teams/$Team1/startAll $port &> serverLog.txt &
  $DIR/teams/$Team2/startAll $port &> serverLog.txt &
  rcssserver server::synch_mode=true server::verbose=off server::port=$port \
  server::coach_port=$coach_port server::olcoach_port=$olcoach_port \
  server::auto_mode=true server::text_log_dir="$DIR/$tmpDirName"\
  server::game_log_dir="$DIR/$tmpDirName" &> serverLog.txt &
  echo "server $port $!" >> $DIR/proc.txt
  wait
}

findResults(){
  #extracting results from log files to adding to new log files
  declare -i i=0
  tmp=`ls $DIR/$tmpDirName/*.rcg`
  i=`expr index $tmp "_"`
  tmp=${tmp:$i}
  i=`expr index $tmp "-vs"`
  rt1=${tmp:0:i-1}
  tmp=${tmp:i+3}
  i=`expr index $tmp "_"`
  tmp=${tmp:i}
  i=`expr index $tmp "."`
  rt2=${tmp:0:i-1}
}

tagging(){
  #tagging and saving results in proper format
  RESULTS_PATH=`tail -n 1 $DIR/path.txt`
  master=`head -n 1 $DIR/masterAddress.txt`

  if [ -n $tag ]
  then
    mkdir -p $DIR/results/$tag

    mv $DIR/$tmpDirName/$logName.rc? $DIR/results/$tag
  else
    mv $DIR/$tmpDirName/$logName.rc? $DIR/results/
  fi

  ssh $master "echo "$tag---$D:$Team1--vs--$Team2:$rt1--$rt2"\
  >>$RESULTS_PATH/Results.txt" </dev/null
  scp -r $DIR/results/* $master:$RESULTS_PATH </dev/null
  rm -r results/*
}
################################################################################
if ! [ -d $DIR/$tmpDirName ]
then
  mkdir $DIR/$tmpDirName
fi

runServerAndAgents
findResults
logName="$Team1--vs--$Team2:$rt1--$rt2--$D"

mv $DIR/$tmpDirName/*.rcg "$DIR/$tmpDirName/$logName.rcg"
mv $DIR/$tmpDirName/*.rcl "$DIR/$tmpDirName/$logName.rcl"

if ! [ -d results ]
then
  mkdir results
fi

tagging

rm -rf $tmpDirName
