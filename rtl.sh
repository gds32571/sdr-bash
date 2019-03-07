#!/bin/bash

let "ctr=0"
while true; do
  echo "$ctr" > "myctr.txt"
  bash rtl2.sh 
  echo $? >> "myerr.txt" 
  sleep 10
  let "ctr+=1"
done
  