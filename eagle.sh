#!/bin/bash

# Starts the EAGLE CAD software using the docker image.
# see also: https://github.com/tombenke/deagle

docker run \
    -it \
    --rm \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /home/tombenke/topics:/home/developer/topics \
    tombenke/eagle:latest \
    /home/developer/eagle-7.7.0/bin/eagle
