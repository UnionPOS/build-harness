#!/usr/bin/env bash
# A collection of functions for working with files.

# shellcheck source=./string.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/array.sh"

# exit without error user is not root
function guard_sudo() {
  if [ "$EUID" -ne 0 ]; then
    echo "this script should only be run as root "
    exit 0
  fi
}

# exit without error if instance service group does not match parameters
function guard_instance_type() {
  if ! array_contains "$INF_SERVICE_GROUP" "$@"; then
    # shellcheck disable=SC2145
    echo "this script should only be run on services instances of tyep [ $@ ]"
    exit 0
  fi
}
