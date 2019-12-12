#! /bin/bash

DIR=`dirname $0`
RESULTS_PATH=`tail -n 1 $DIR/path.txt`

rm -rf $RESULTS_PATH
