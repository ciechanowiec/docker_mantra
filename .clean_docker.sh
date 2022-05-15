#!/bin/bash

allContainersIDs=$(docker ps -aq)
allImagesIDs=$(docker images -aq)

if [ ${#allContainersIDs} == 0 ]
then
	echo "[INFO]: There is no Docker containers to remove"
else
	echo "[INFO]: Removing Docker containers..."
	docker rm -vf $allContainersIDs
fi

if [ ${#allImagesIDs} == 0 ]
then
	echo "[INFO]: There is no Docker images to remove"
else
	echo "[INFO]: Removing Docker images..."
	docker rmi -f $allImagesIDs
fi
