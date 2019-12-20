#! /bin/bash

DIR=`dirname $0`

main() {
  resultsDir=`tail -n 1 $DIR/path.txt`

  read -t 10 -p "Enter tag of the results you want: " tag

  if ! [[ -n $tag ]] ; then
    if [[ -r "$resultsDir/Results.txt" ]] ; then
      declare -i i=0
      while IFS= read -r line ; do
        i=`expr index $line ": "`
        game=${line:$i}
        i=`expr index $line "---"`
        tag=${line:0:$i-1}
        echo "$game -> $tag"
      done < $resultsDir/Results.txt
    fi
  else
    if [[ -d $resultsDir/$tag ]] && [[ -r $resultsDir/$tag/Results.txt ]] ; then
      declare -i i=0
      while IFS= read -r line ; do
        tmp=$line
        i=`expr index $tmp ": "`
        tmp=${tmp:$i+1}
        echo $tmp
      done < $resultsDir/$tag/Results.txt
    fi
  fi
}

main
