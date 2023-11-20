!#/bin/bash


for image in $(docker images | awk '{print $3}') 
do
  docker image rm -f $image
done
