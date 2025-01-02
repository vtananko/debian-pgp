#!/bin/bash

# Build image on local PC and push it on ghcr.io

DEBIAN_MAJOR="12"

GHCR_PAT_FILE=~/prj/docker/github.pat
GHCR_USERNAME=vtananko
REPO_NAME="debian-pgp"

if [ "$1" == "ghcr" ]; then
	TAG_PREFIX="ghcr.io/$GHCR_USERNAME/$REPO_NAME"
else
	TAG_PREFIX="$REPO_NAME"
fi

TAG_NAME="$TAG_PREFIX:$DEBIAN_MAJOR"


docker build -t $TAG_NAME \
	--build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
	.
(( $? == 0 )) || exit 2

VERSION=`docker run -t --rm $TAG_NAME cat /etc/debian_version | tr -d '\r'`

docker tag $TAG_NAME $TAG_PREFIX:$VERSION

if [ "$1" == "ghcr" ]; then
	echo "GHCR start..."
	if [ ! -f $GHCR_PAT_FILE ]; then
		echo "Not have GitHub Personal Access Token file. Exit."
		exit 3
	fi
	echo "Docker login to ghcr.io..."
	cat $GHCR_PAT_FILE | docker login ghcr.io -u $GHCR_USERNAME --password-stdin
	echo "Docker push to ghcr.io..."
	docker push -a ghcr.io/$GHCR_USERNAME/$REPO_NAME
fi
