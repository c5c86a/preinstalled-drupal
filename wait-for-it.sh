#!/usr/bin/env bash

COUNTER=0
HOST=`cat /host`
while [  $COUNTER -lt $2 ]; do
  let COUNTER=COUNTER+1 
  nc -z $HOST $1  
  if [ "$?" -eq 0 ]; then
    break
  else
    sleep 1
  fi
done
