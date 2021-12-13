#!/bin/bash -e

DIRNAME=$(dirname "$0")

#docker volume create --name debexports
containerID=$(docker run --detach magnetikonline/buildnginx)
docker cp "$containerID:/debexports" "/Users/german/DevOPS/task1/"
sleep 1
docker rm "$containerID"