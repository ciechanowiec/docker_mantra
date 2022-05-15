#!/bin/bash

allContainersIDs=$(docker ps -aq)
allImagesIDs=$(docker images -aq)

docker rm -vf $allContainersIDs
docker rmi -f $allImagesIDs
