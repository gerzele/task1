#!/bin/bash

#docker volume create --name debexports
#containerID=$(docker run --detach XXXX)
#docker cp "$containerID:/debexports" "/Users/german/DevOPS/task1/"
#sleep 1
#docker rm "$containerID"

docker run -d \
  --name=myimg:builder1 \
  --mount source=debexports,destination=/debexport
