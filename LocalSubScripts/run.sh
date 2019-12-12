#! /bin/bash
#$1 ---> team1
#$2 ---> team2
#$3 ---> port
#$4 ---> tag

DIR=`dirname $0`
PARENT_DIR=`dirname $DIR`
#############################variables
declare -i port=$3
declare -i coach_port=$3+1
declare -i olcoach_port=$3+2

tag=$4
teamsDIR=`head -n 1 path.txt`
resultDIR=`tail -n 1 path.txt`

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
  $PARENT_DIR/$teamsDIR/$Team1/startAll $port &> $DIR/serverLog.txt &
  $PARENT_DIR/$teamsDIR/$Team2/startAll $port &> $DIR/serverLog.txt &
  rcssserver server::synch_mode=true server::verbose=off server::port=$port \
  server::coach_port=$coach_port server::olcoach_port=$olcoach_port \
  server::text_log_dir="$PARENT_DIR/$tmpDirName" server::game_log_dir="$PARENT_DIR/$tmpDirName" \
  server::auto_mode=true &> $DIR/serverLog.txt &
  echo "server $port $!" >> $PARENT_DIR/proc.txt
  wait
}
findResults(){
  #extracting results from log files to adding to new log files
  declare -i i=0
  tmp=`ls $PARENT_DIR/$tmpDirName/*.rcg`
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
createResultDirectory(){
  if ! [ -d $resultDIR ] ; then
    mkdir $resultDIR
  fi
}
makeTag(){
  #tagging
  if [ -n $tag ] ; then
    if ! [ -d $resultDIR/$tag ] ; then
      mkdir $resultDIR/$tag
    fi

    mv $PARENT_DIR/$tmpDirName/$logName.rc? $resultDIR/$tag
  else
    mv $PARENT_DIR/$tmpDirName/$logName.rc? $resultDIR/
  fi

  echo "$tag --- $D: $Team1-$rt1-vs-$Team2-$rt2" >>$resultDIR/Results.txt
}
#####################################



if ! [ -d $tmpDirName ] ; then
  mkdir $tmpDirName
fi

runServerAndAgents
findResults
logName="$Team1-$rt1-vs-$Team2-$rt2-$D"

mv $PARENT_DIR/$tmpDirName/*.rcg "$PARENT_DIR/$tmpDirName/$logName.rcg"
mv $PARENT_DIR/$tmpDirName/*.rcl "$PARENT_DIR/$tmpDirName/$logName.rcl"

createResultDirectory

makeTag
rm -rf $tmpDirName
