#!/usr/bin/env bash

# Sets some Bash options to encourage well formed code.
# For example, some of the options here will cause the script to terminate as
# soon as a command fails. Another option will cause an error if an undefined
# variable is used.
# See: https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html

# Any trap on ERR is inherited by shell functions, command substitutions, and
# commands executed in a subshell environment. The ERR trap is normally not
# inherited in such cases.
set -o errtrace

# Any trap on DEBUG and RETURN are inherited by shell functions, command
# substitutions, and commands executed in a subshell environment. The DEBUG and
# RETURN traps are normally not inherited in such cases.
set -o functrace

# Exit if any command exits with a non-zero exit status.
set -o errexit

# Exit if script uses undefined variables.
set -o nounset

# Prevent masking an error in a pipeline.
# Look at the end of the 'Use set -e' section for an excellent explanation.
# see: https://www.davidpashley.com/articles/writing-robust-shell-scripts/
set -o pipefail

# Make debugging easier when you use `set -x`
# See: http://wiki.bash-hackers.org/scripting/debuggingtips#making_xtrace_more_useful
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

[[ -n ${DEBUG:-} ]] && echo "Enabling debug mode" && set -x

# setup traps for error, exit, and interrupt
function on_error() {
  error_msg="$0 task error: ${1:-}"

  log_dump=""
  if [ -f "$STDERR_LOG" ]
  then
    log_dump=$(cat "$STDERR_LOG")
  fi

  if [[ ! -z "$INF_ERROR_CHANNEL" ]]
  then
    # if INF_ERROR_CHANNEL is set send slack notification
    # shellcheck disable=SC1117
    /opt/union/bin/union-slack-msg "$INF_ERROR_CHANNEL" "$error_msg\n$log_dump" "#ffccaa"
  else
    # if INF_ERROR_CHANNEL is not set send output to console
    echo "$error_msg"
    echo "$log_dump"
  fi
}

function on_exit() {
  local exit_code="${1:-0}"
  exit "${exit_code}"
}

function on_interrupt() {
  true # override this in scripts to perform post-interrupt actions
}

function catch_error() {
  local this_script="$0"
  local exit_code="$1"
  local err_lineno="$2"
  echo "$this_script: line $err_lineno: exiting with status ${exit_code}"
  # shellcheck disable=SC2068
  on_error $@
}

function catch_exit() {
  # shellcheck disable=SC2068
  on_exit $@
}

function catch_interrupt() {
  local this_script="$0"
  local exit_code="$1"
  local err_lineno="$2"
  echo "$this_script: line $err_lineno: interrupted"
  # shellcheck disable=SC2068
  on_interrupt $@
  on_exit 0 # without this an interrupt will also be caught as an error (non 0 exit status)
}

# trap ctrl-c and call ctrl_c()
trap 'catch_interrupt $? ${LINENO}' INT
# trap errors and allow post-error action
trap 'catch_error $? ${LINENO}' ERR
# trap script exit
trap 'catch_exit $?' EXIT

TMPDIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'TMPDIR')
export STDOUT_LOG="${TMPDIR}/stdout.log"
export STDERR_LOG="${TMPDIR}/stderr.log"
