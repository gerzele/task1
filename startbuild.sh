#!/bin/bash
#Script to create environment\build package and put resulting *deb into /debresult tolder
#docker volume create --name debexports
docker build -t myimg:builder1 .
docker run -d --name=deb_builder1 --mount type=bind,source="$(pwd)"/debresult,target=/debexport/ myimg:builder1