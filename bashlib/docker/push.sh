#!/usr/bin/env bash

# Docker push functions

function docker_push() {
    local IMAGE_NAME="$1"

    docker push \
    "$IMAGE_NAME"

}
export -f docker_push
