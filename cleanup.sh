#!/bin/bash
#Script to cleanup during debug
docker rm deb_builder1
docker rmi myimg:builder1
