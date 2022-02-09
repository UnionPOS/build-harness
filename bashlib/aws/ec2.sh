#!/usr/bin/env bash

# AWS ec2 functions

function ec2_cluster_ips() {
  local REGION="${1:-$INF_REGION}"
  local TAG="${2:-$INF_INSTANCE_NAME}"
  echo "ec2_cluster_ips $REGION $TAG"
  aws ec2 describe-instances \
    --query "Reservations[*].Instances[*].PrivateIpAddress" \
    --filters "Name=tag:Name,Values=$TAG" \
    --region "$REGION" \
    --output text
}
export -f ec2_cluster_ips

function ec2_is_duty_instance() {
  IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
  CLUSTER=$(ec2_cluster_ips "$INF_REGION" "$INF_INSTANCE_NAME")
  DUTY=$(echo "$CLUSTER" | xargs -n1 | sort -u | xargs | awk '{print $1}')

  if [[ "$IP" != "$DUTY" ]]
  then
    echo "no"
  else
    echo "yes"
  fi
}
export -f ec2_is_duty_instance

function ec2_private_ip() {
  local INSTANCE_ID="$1"

  aws ec2 describe-instances \
    --filters "Name=instance-id,Values=$INSTANCE_ID" \
    --query "Reservations[*].Instances[*].PrivateIpAddress" \
    --output text
}
export -f ec2_private_ip

function ec2_is_instance_running() {
  local INSTANCE_ID="$1"

  state=`aws ec2 describe-instance-status \
        --instance-ids "$INSTANCE_ID" \
        --query 'InstanceStatuses[0].InstanceState.Name' \
        --output text`
  if [ $state == 'running' ]
  then
    return 0
  else
    return 1
  fi
}
export -f ec2_is_instance_running

function terminate_instances() {
  local INSTANCE_ID="$1"

  if ec2_is_instance_running $INSTANCE_ID; then
    aws ec2 terminate-instances \
    --instance-ids "$INSTANCE_ID"
  else
    echo "Instance $INSTANCE_ID not in running state, skipping"
  fi
}
export -f terminate_instances


