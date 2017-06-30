#!/bin/sh

# Ease the process to push a local image to my private registry

SERVER=crystal.cw:5000

image="$1"

docker tag $image $SERVER/$image
docker push $SERVER/$image
