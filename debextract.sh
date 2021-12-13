#!/bin/bash

#docker volume create --name debexports
containerID=$(docker run --detach magnetikonline/buildnginx)
docker cp "$containerID:/debexports" "/Users/german/DevOPS/task1/"
sleep 1
docker rm "$containerID"