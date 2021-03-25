#!/usr/bin/env bash

# AWS Step Function functions
function stepfunction_invoke() {
  local state_machine_arn="$1"
  local payload="$2"
  local region="${AWS_REGION:-"us-west-2"}"
  local results_file="stepfunction_invoke_result"

  result="$(aws stepfunctions start-execution \
    --state-machine-arn "$state_machine_arn" \
    --input "$payload"
    )"

  echo $result
}

export -f stepfunction_invoke
