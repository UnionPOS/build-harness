#!/usr/bin/env bash

function get_valid_doctypes() {
  echo "employee-status employee-status-server end-of-day-status menu menu-schedule menu-overrides online-order payments-client tab tab-customers-server tab-customers-client venue venue-customers"
}

function get_valid_stacks() {
  echo "mgmt dev qa prod"
}

function get_valid_service_groups() {
  echo "vpn bots api build couchbase couchbasexdcr couchworker foundry logiapp mdm mdmworker sftp sqsworker syncgateway smithers"
}

function is_empty() {
  local var="$1"
  [ -z "$var" ]
}

function is_not_empty() {
  local var="$1"
  [ -n "$var" ]
}

function is_file() {
  local file="$1"
  [ -f "$file" ]
}

function is_not_file() {
  local file="$1"
  [ ! -f "$file" ]
}

function is_dir() {
  local dir="$1"
  [ -d "$dir" ]
}

function is_not_dir() {
  local dir="$1"
  [ ! -d "$dir" ]
}

function is_number() {
  local value="$1"
  [[ "$value" =~ ^[0-9]+$ ]]
}

function is_not_number() {
  local value="$1"
  [[ ! "$value" =~ ^[0-9]+$ ]]
}

function contains() {
  local list="$1"
  local item="$2"
  [[ $list =~ (^|[[:space:]])"$item"($|[[:space:]]) ]]
}

function is_valid_stack() {
  local stack="$1"
  local valid="$(get_valid_stacks)"
  if ! contains "$valid" "$stack"; then
    (>&2 echo "invalid stack $stack")
    exit 1
  fi
  echo "$stack"
}

function is_valid_service_group() {
  local group="$1"
  local valid="$(get_valid_service_groups)"
  if ! contains "$valid" "$group"; then
    (>&2 echo "invalid service group $group")
    exit 1
  fi
  echo "$group"
}

function is_valid_terminal_id() {
  local terminal_id="$1"
  if ! is_number "$terminal_id"; then
    (>&2 echo "terminal_id should be a number")
    exit 1
  fi
  echo "$terminal_id"
}

function is_valid_venue_id() {
  local venue_id="$1"
  if ! is_number "$venue_id"; then
    (>&2 echo "venue_id should be a number")
    exit 1
  fi
  echo "$venue_id"
}

function is_valid_doctype() {
  local stack="$1"
  local valid="$(get_valid_doctypes)"
 if ! contains "$valid" "$stack"; then
    (>&2 echo "invalid stack $stack")
    exit 1
  fi
  echo "$stack"
}
