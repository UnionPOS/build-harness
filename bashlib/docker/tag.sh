#!/usr/bin/env bash

# Docker tag functions

#Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE
function docker_tag() {
    local SOURCE_IMAGE="$1"
    local TARGET_IMAGE="$2"

    docker tag \
    "$SOURCE_IMAGE" "$TARGET_IMAGE"

}
export -f docker_tag
