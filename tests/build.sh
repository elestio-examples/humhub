#!/usr/bin/env bash

rm docker-compose.yml
mv docker-compose-new.yml docker-compose.yml

HUMHUB_VERSION="$(awk '$0 ~ /^([0-9\.]+) [0-9\.]+ latest/ {print $1}' versions.txt)"
VCS_REF="$(git rev-parse --short HEAD)"

sed -i 's/ARG HUMHUB_VERSION/ARG HUMHUB_VERSION='"${HUMHUB_VERSION}"'/g' Dockerfile
sed -i 's/ARG VCS_REF/ARG VCS_REF='"${VCS_REF}"'/g' Dockerfile
docker buildx build . --output type=docker,name=elestio4test/humhub:latest | docker load
