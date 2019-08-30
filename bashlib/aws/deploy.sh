#!/usr/bin/env bash

# AWS deploy functions

function deploy_get_deployment() {
  local DEPLOY_ID="$1"

  aws deploy get-deployment \
    --deployment-id "$DEPLOY_ID"
}
export -f deploy_get_deployment

function deploy_update_deployment_group() {
  local APP_NAME="$1"
  local GROUP_NAME="$2"
  local ASG_NAME="$3"

  aws deploy update-deployment-group \
    --application-name "$APP_NAME" \
    --current-deployment-group-name "$GROUP_NAME" \
    --auto-scaling-groups "$ASG_NAME"
}
export -f deploy_update_deployment_group

function deploy_push() {
  local APP_NAME="$1"
  local SOURCE="$2"
  local LOCATION="$3"

  aws deploy push \
    --application-name "$APP_NAME" \
    --s3-location "$LOCATION" \
    --source "$SOURCE"
}
export -f deploy_push

function deploy_create_deployment() {
  local APP_NAME="$1"
  local LOCATION="$2"
  local DEPLOYMENT_GROUP_NAME="$3"

  aws deploy create-deployment \
    --application-name "$APP_NAME" \
    --s3-location "$LOCATION" \
    --deployment-group-name "$DEPLOYMENT_GROUP_NAME" \
    --file-exists-behavior "OVERWRITE"
}
export -f deploy_create_deployment

function deploy_wait() {
  local DEPLOY_ID="$1"

  aws deploy wait deployment-successful \
    --deployment-id "$DEPLOY_ID"
}
export -f deploy_wait

function deploy_get_latest_revision() {
  local APP_NAME="$1"

  s3_key=$(
    aws deploy list-application-revisions \
        --application-name "$APP_NAME" \
        --sort-by lastUsedTime \
        --sort-order descending \
        --deployed include \
        --max-items 1 \
        --query "revisions[*].s3Location.key" \
    | jq -rc .[]
  )
  echo "$s3_key"
}
