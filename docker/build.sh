#!/bin/bash

USER=casperklein
NAME=webserver-pack
TAG=latest

[ -n "$USER" ] && TAG=$USER/$NAME:$TAG || TAG=$NAME:$TAG

DIR=${0%/*}
cd "$DIR" &&
echo "Building: $TAG" &&
echo &&	
docker build -t $TAG .
