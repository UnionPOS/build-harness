#!/usr/bin/env bash

# Docker image functions

function docker_inspect() {
    local IMAGE_NAME="$1"

    docker image inspect \
    "$IMAGE_NAME"

}
export -f docker_inspect
