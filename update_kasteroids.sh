#!/bin/bash

docker ps -a | awk '{ print $1,$2 }' | grep etdofresh/kasteroids | awk '{ print $1 }' | xargs -I {} docker rm -f {}
docker rmi -f etdofresh/kasteroids
docker run -dp 11001:11001 etdofresh/kasteroids
