#!/usr/bin/env bash

# AWS autoscaling functions

function asg_describe() {
  local ASG_NAME="$1"

  aws autoscaling describe-auto-scaling-groups \
    --auto-scaling-group-names "$ASG_NAME"
}
export -f asg_describe

function asg_name_from_tag() {
  local KEY="$1"
  local VALUE="$2"
  aws autoscaling describe-auto-scaling-groups \
    --query "AutoScalingGroups[? Tags[? (Key=='${KEY}') && Value=='${VALUE}']]".AutoScalingGroupName  \
    --output text
}
export -f asg_name_from_tag


function asg_describe_instance() {
  local ASG_NAME="$1"
  local INSTANCE_ID="$2"

  aws autoscaling describe-auto-scaling-instances \
    --instance-ids "$INSTANCE_ID" \
    --query "AutoScalingInstances[?contains(AutoScalingGroupName, '$ASG_NAME')]"
}
export -f asg_describe_instance

function asg_describe_instances() {
  local ASG_NAME="$1"

  aws autoscaling describe-auto-scaling-instances \
    --query "AutoScalingInstances[?contains(AutoScalingGroupName, '$ASG_NAME')].InstanceId"
}
export -f asg_describe_instances

function asg_describe_healthy_instances() {
  local ASG_NAME="$1"

  aws autoscaling describe-auto-scaling-instances \
    --query "AutoScalingInstances[?(AutoScalingGroupName=='$ASG_NAME' && HealthStatus=='HEALTHY')].InstanceId"
}
export -f asg_describe_healthy_instances

function asg_describe_lifecycle_hooks() {
  local ASG_NAME="$1"

  aws autoscaling describe-lifecycle-hooks \
    --auto-scaling-group-name "$ASG_NAME" \
    --query "LifecycleHooks[*].LifecycleHookName"
}
export -f asg_describe_lifecycle_hooks

function asg_attach_instances() {
  local ASG_NAME="$1"
  local INSTANCE_ID="$2"

  aws autoscaling attach-instances \
    --instance-ids "$INSTANCE_ID" \
    --auto-scaling-group-name "$ASG_NAME"
}
export -f asg_attach_instances

function asg_delete() {
  local ASG_NAME="$1"

  aws autoscaling delete-auto-scaling-group \
    --auto-scaling-group-name "$ASG_NAME" \
    --force-delete
}
export -f asg_delete

function asg_delete_lifecycle_hook() {
  local ASG_NAME="$1"
  local HOOK_NAME="$2"

  aws autoscaling delete-lifecycle-hook \
    --auto-scaling-group-name "$ASG_NAME" \
    --lifecycle-hook-name "$HOOK_NAME"
}
export -f asg_delete_lifecycle_hook

function asg_detach_instances() {
  local ASG_NAME="$1"
  local INSTANCE_ID="$2"

  aws autoscaling detach-instances \
    --instance-ids "$INSTANCE_ID" \
    --auto-scaling-group-name "$ASG_NAME" \
    --should-decrement-desired-capacity
}
export -f asg_detach_instances

function asg_resume_processes() {
  local ASG_NAME="$1"

  aws autoscaling resume-processes \
    --auto-scaling-group-name "$ASG_NAME"
}
export -f asg_resume_processes

function asg_set_instance_health() {
  local ID="$1"
  local STATUS="${2:-"Healthy"}"

  aws autoscaling set-instance-health \
    --instance-id "$ID" \
    --health-status "$STATUS"
}
export -f asg_set_instance_health

function asg_suspend_processes() {
  local ASG_NAME="$1"

  aws autoscaling suspend-processes \
    --auto-scaling-group-name "$ASG_NAME"
}
export -f asg_suspend_processes

function asg_set_desired_size() {
  local ASG_NAME="$1"
  local SIZE="$2"

  aws autoscaling update-auto-scaling-group \
    --auto-scaling-group-name "$ASG_NAME" \
    --desired-capacity "$SIZE"
}
export -f asg_set_desired_size

function asg_set_max_size() {
  local ASG_NAME="$1"
  local SIZE="$2"

  aws autoscaling update-auto-scaling-group \
    --auto-scaling-group-name "$ASG_NAME" \
    --max-size "$SIZE"
}
export -f asg_set_max_size

function asg_set_min_size() {
  local ASG_NAME="$1"
  local SIZE="$2"

  aws autoscaling update-auto-scaling-group \
    --auto-scaling-group-name "$ASG_NAME" \
    --min-size "$SIZE"
}
export -f asg_set_min_size

function asg_set_size() {
  local ASG_NAME="$1"
  local SIZE="$2"

  aws autoscaling update-auto-scaling-group \
    --auto-scaling-group-name "$ASG_NAME" \
    --desired-capacity "$SIZE" \
    --max-size "$SIZE" \
    --min-size "$SIZE"
}
export -f asg_set_size

function asg_wait_detached() {
  local ASG_NAME="$1"
  local INSTANCE_ID="$2"

  DONE=0
  while [ "$DONE" = "0" ];do
    sleep 15
    STATUS=$(asg_describe_instance "$ASG_NAME" "$INSTANCE_ID")
    if [ "$STATUS" = "[]" ]; then
      DONE=1
    else
      printf "."
      # echo $STATUS
    fi
  done
}
export -f asg_wait_detached
