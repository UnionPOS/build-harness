#!/usr/bin/env bash

# AWS rds functions
# https://docs.aws.amazon.com/cli/latest/reference/rds/delete-db-instance.html
function rds_instance_delete() {
  local id="$1"
  aws rds delete-db-instance \
      --db-instance-identifier "$id" \
      --final-db-snapshot-identifier "${id}-$(date +%m-%d-%Y)"
}
export -f rds_instance_delete


# https://docs.aws.amazon.com/cli/latest/reference/rds/modify-db-instance.html
function rds_instance_rename() {
  local id="$1"
  local new_id="$2"
  aws rds modify-db-instance \
    --db-instance-identifier "$id" \
    --apply-immediately \
    --new-db-instance-identifier "$new_id"
}
export -f rds_instance_rename

# https://docs.aws.amazon.com/cli/latest/reference/rds/modify-db-instance.html
function rds_instance_upgrade() {
  local id="$1"
  local version="$2"
  aws rds modify-db-instance \
    --db-instance-identifier "$id" \
    --ca-certificate-identifier "rds-ca-2019" \
    --apply-immediately \
    --engine-version "$version"
}
export -f rds_instance_upgrade

# https://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance-read-replica.html
function rds_replica_create() {
  local id_src="$1"
  local id_dst="$2"
  aws rds create-db-instance-read-replica \
      --db-instance-identifier "$id_dst" \
      --source-db-instance-identifier "$id_src" \
      --monitoring-interval 60 \
      --monitoring-role-arn 'arn:aws:iam::731646523614:role/rds-monitoring-role' \
      --enable-cloudwatch-logs-exports '["audit","error","general","slowquery"]'
}
export -f rds_replica_create

# https://docs.aws.amazon.com/cli/latest/reference/rds/promote-read-replica.html
function rds_replica_promote() {
  local id="$1"
  aws rds promote-read-replica \
      --db-instance-identifier "$id"
}
export -f rds_replica_promote

# the provided rds wait command is not very robust.
# it can take some time for an instance returns any result which will return error
# this will allow for that error and continue to check until desired result state is returned.
function rds_wait_until_status() {
  local id="$1"
  local desired="${2:-"available"}"
  local delay="${3:-120}"
  local status=""

  until [[ "$desired" = "$status" ]]
  do
    sleep $delay # delay before start checking
    set +e # do not exit on error
    status="$(aws rds describe-db-instances --db-instance-identifier "$id" | jq -r '.DBInstances[].DBInstanceStatus' 2>&1)"
    set -e
    printf "."
  done
}
