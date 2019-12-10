#! /bin/bash
#$1 ---> team1
#$2 ---> team2
#$3 ---> port
#$4 ---> global_tag
#$5 ---> tag

DIR=`dirname $0`
#############################variables
declare -i port=$3
declare -i coach_port=$3+1
declare -i olcoach_port=$3+2

global_tag=$4
tag=$5

Team1=$1
Team2=$2
#finding date for adding to log files
D="$(date +%Y%m%d%H%M%S)"
tmpDirName="$Team1-$Team2"
rt1=""
rt2=""
##############################methods
runServerAndAgents(){
  #running Games
  $DIR/teams/$Team1/startAll $port &> serverLog.txt &
  $DIR/teams/$Team2/startAll $port &> serverLog.txt &
  rcssserver server::synch_mode=true server::verbose=off server::port=$port \
  server::coach_port=$coach_port server::olcoach_port=$olcoach_port \
  server::auto_mode=true server::text_log_dir="$DIR/$tmpDirName"\
  server::game_log_dir="$DIR/$tmpDirName" &> serverLog.txt &
  echo "server $port $!" >> ../proc.txt
  wait
}
findResults(){
  #extracting results from log files to adding to new log files
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
}
tagging(){
  #tagging
if [ -n $global_tag ]
then
  if ! [ -d results/$global_tag ]
  then
    mkdir results/$global_tag
  fi

  if [ -n $tag ]
  then
    if ! [ -d results/$global_tag/$tag ]
    then
      mkdir results/$global_tag/$tag
    fi

    mv $tmpDirName/$logName.rc? results/$global_tag/$tag
  else
    mv $tmpDirName/$logName.rc? results/$global_tag/
  fi

  echo "$tag --- $D: $Team1-$rt1-vs-$Team2-$rt2" \
  >>results/$global_tag/Results.txt
else
  if [ -n $tag ]
  then
    if ! [ -d results/$tag ]
    then
      mkdir results/$tag
    fi

    mv $tmpDirName/$logName.rc? results/$tag
  else
    mv $tmpDirName/$logName.rc? results/
  fi

  echo "$tag --- $D: $Team1-$rt1-vs-$Team2-$rt2" >>results/Results.txt
fi
}
#####################################



if ! [ -d $tmpDirName ]
then
  mkdir $tmpDirName
fi

runServerAndAgents
cd $tmpDirName
findResults
logName="$Team1-$rt1-vs-$Team2-$rt2-$D"

mv ./*.rcg "$logName.rcg"
mv ./*.rcl "$logName.rcl"

cd ..

if ! [ -d results ]
then
  mkdir results
fi

tagging
rm -rf $tmpDirName
