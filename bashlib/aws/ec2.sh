#!/usr/bin/env bash

# AWS ec2 functions

function ec2_private_ip() {
  local INSTANCE_ID="$1"

  aws ec2 describe-instances \
    --filters "Name=instance-id,Values=$INSTANCE_ID" \
    --query "Reservations[*].Instances[*].PrivateIpAddress" \
    --output text
}
export -f ec2_private_ip

function terminate_instances() {
  local INSTANCE_ID="$1"

  aws ec2 terminate-instances \
    --instance-ids "$INSTANCE_ID"
}
export -f terminate_instances

