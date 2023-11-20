#!/bin/bash


for id in $(docker images | awk '{print $1 "\t" $3}' | grep none | awk '{print $2}')
do
  docker image rm $id
done
