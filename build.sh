#!/bin/sh

. ./setenv.sh
sudo docker build -t karaf:${DOCKER_VERSION} .