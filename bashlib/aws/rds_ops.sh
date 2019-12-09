#!/usr/bin/env bash

LIBDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=./autoscaling.sh
source "${LIBDIR}/autoscaling.sh"
# shellcheck source=./rds.sh
source "${LIBDIR}/rds.sh"
# shellcheck source=./../echos.sh
source "${LIBDIR}/../echos.sh"

# AWS rds operations functions

function rds_ops_launch_read_replica() {
  local source="$1"
  local replica="$2"
  local version="${3:-""}"

  action "create read replica $replica from $source"
  rds_replica_create "$source" "$replica"

  action "waiting for $replica to complete create"
  rds_wait_until_status "$replica" "available"

  if [ "$version" != "" ]
  then
    action "upgrade $replica engine version to $VERSION"
    rds_instance_upgrade "$replica" "$version"

    action "waiting for $replica to complete upgrade"
    rds_wait_until_status "$replica" "available"
  fi
}
export -f rds_ops_launch_read_replica

function rds_ops_promote_read_replica() {
  local replica="$1"

  action "promoting $replica to master instance"
  rds_replica_promote "$replica"

  action "waiting for $replica to complete promotion"
  rds_wait_until_status "$replica" "available"
}
export -f rds_ops_promote_read_replica

function rds_ops_rename_instance() {
  local old_name="$1"
  local new_name="$2"

  action "renaming db instance $old_name to $new_name"
  rds_instance_rename "$old_name" "$new_name"

  action "waiting for $old_name to be renamed $new_name"
  rds_wait_until_status "$new_name" "available"
}
export -f rds_ops_rename_instance

function rds_ops_maintenance_mode_enable() {
  local stack="$1"
  local api_asg="$(asg_name_from_tag "Name" "up-union-${stack}-api-instance")"
  local couchworker_asg="$(asg_name_from_tag "Name" "up-union-${stack}-couchworker-instance")"

  # ensure required scripts are reachable
  test -f "$DIR/../ec2/workers" || echo "can't fine workers script"
  test -f "$DIR/../maintenance" || echo "can't fine maintenance script"

  action "disable ELB health checks for api"
  asg_set_health_check_type "$api_asg" "EC2"

  action "disable autoscaling for couchworker"
  asg_suspend_processes "$couchworker_asg"

  action "stop all worker processes"
  "$DIR/../ec2/workers" "$stack" "stop"

  action "enable maintenance mode"
  "$DIR/../maintenance" "$stack" "on"
}
export -f rds_ops_maintenance_mode_enable

function rds_ops_maintenance_mode_disable() {
  local stack="$1"
  local api_asg="$(asg_name_from_tag "Name" "up-union-${stack}-api-instance")"
  local couchworker_asg="$(asg_name_from_tag "Name" "up-union-${stack}-couchworker-instance")"

  # ensure required scripts are reachable
  test -f "$DIR/../ec2/workers" || echo "can't fine workers script"
  test -f "$DIR/../maintenance" || echo "can't fine maintenance script"

  action "disable maintenance mode"
  "$DIR/../maintenance" "$stack" "off"

  action "start all worker processes"
  "$DIR/../ec2/workers" "$stack" "start"

  action "enable autoscaling for couchworker"
  asg_resume_processes "$couchworker_asg"

  action "enable ELB health checks for api"
  asg_set_health_check_type "$api_asg" "ELB"
}
export -f rds_ops_maintenance_mode_disable

