#!/usr/bin/env bash

# AWS ecr functions

export ecr_registry_url="731646523614.dkr.ecr.us-west-2.amazonaws.com"

function ecr_describe_repository() {
    local REPO_NAME="$1"

    aws ecr describe-repositories \
    --repository-name "$REPO_NAME"

}
export -f ecr_describe_repository

function ecr_auth_docker_client() {
    aws ecr get-login-password \
    --region us-west-2 | docker login --username AWS --password-stdin $ecr_registry_url
}
export -f ecr_auth_docker_client
