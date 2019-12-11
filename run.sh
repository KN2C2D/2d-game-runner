#! /bin/bash
#$1 ---> team1
#$2 ---> team2
#$3 ---> port
#$4 ---> tag

DIR=`dirname $0`
cd $DIR
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
  if [[  $teamsDIR = "" ]] ; then
    teamsDIR=$DIR/teams
  fi
  #running Games
  ../$teamsDIR/$Team1/startAll $port &
  ../$teamsDIR/$Team2/startAll $port &
  rcssserver server::synch_mode=true server::verbose=off server::port=$port \
  server::coach_port=$coach_port server::olcoach_port=$olcoach_port \
  server::auto_mode=true  &
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
createResultDirectory(){
  if [[  $resultDIR = "" ]] ; then
    if ! [ -d results ] ; then
      mkdir results
    fi
    resultDIR=results
  fi
}
makeTag(){
  #tagging
  if [ -n $tag ] ; then
    if ! [ -d $resultDIR/$tag ] ; then
      mkdir $resultDIR/$tag
    fi

    mv $tmpDirName/$logName.rc? $resultDIR/$tag
  else
    mv $tmpDirName/$logName.rc? $resultDIR/
  fi

  echo "$tag --- $D: $Team1-$rt1-vs-$Team2-$rt2" >>results/Results.txt
fi
}
#####################################



if ! [ -d $tmpDirName ] ; then  
  mkdir $tmpDirName
fi
cd $tmpDirName

runServerAndAgents
findResults
logName="$Team1-$rt1-vs-$Team2-$rt2-$D"

mv ./*.rcg "$logName.rcg"
mv ./*.rcl "$logName.rcl"

cd ..

createResultDirectory

makeTag
rm -rf $tmpDirName
