#! /bin/bash

DIR=`dirname $0`
``
main() {
  resultsDir=`tail -n 1 $DIR/path.txt`

  savePath=""
  declare -i saveFlag=0
  read -t 10 -p "Do you want to save results in a file? (y/n): " doSave
  echo

  if [[ ${doSave[0]} == 'y' ]] || [[ ${doSave[0]} == 'Y' ]] ; then
    read -t 30 -p "Enter path of the save File: " savePath
    if ! [[ -n $savePath ]] ; then
      savePath="$DIR/Saved_Results.txt"
    fi
    saveFlag=1
    echo $savePath
  fi

  read -t 10 -p "Enter tag of the results you want: " tag
  echo

  if ! [[ -n $tag ]] ; then
    if [[ -r "$resultsDir/Results.txt" ]] ; then
      declare -i i=0
      while IFS= read -r line ; do
        i=`expr index $line ": "`
        game=${line:$i}
        i=`expr index $line "---"`
        tag=${line:0:$i-1}
        echo "$game -> $tag"
        if [[ $saveFlag -eq 1 ]] ; then
          echo "$game -> $tag" >>$savePath
        fi
      done < $resultsDir/Results.txt
    fi
  else
    if [[ -d $resultsDir/$tag ]] && [[ -r $resultsDir/$tag/Results.txt ]] ; then
      declare -i i=0
      while IFS= read -r line ; do
        tmp=$line
        i=`expr index $tmp ": "`
        tmp=${tmp:$i}
        echo $tmp
        if [[ $saveFlag -eq 1 ]] ; then
          echo "$tmp" >>$savePath
        fi
      done < $resultsDir/$tag/Results.txt
    fi
  fi
}

main
