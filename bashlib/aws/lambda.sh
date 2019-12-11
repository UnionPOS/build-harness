#!/usr/bin/env bash

# AWS Lambda functions

function lambda_invoke() {
  local invocation_type="RequestResponse"
  local log_type="Tail"
  local function_name="$1"
  local payload="$2"
  local region="${AWS_REGION:-"us-west-2"}"
  local results_file="lambda_invoke_result"

  result="$(aws lambda invoke \
    --invocation-type "$invocation_type" \
    --function-name "$function_name" \
    --region "$region" \
    --log-type "$log_type" \
    --payload "$payload" \
    "$results_file")"

  if [[ -n ${DECODE:-} ]]
  then
    echo "#######################################################################"
    echo "StatusCode: $(echo "$result" | jq .StatusCode)"
    echo "LogResult: "
    echo "$(echo "$result" | jq -r .LogResult | base64 -d)"
    echo "#######################################################################"
  fi

  cat "$results_file" | jq
  rm "$results_file"
}
export -f lambda_invoke
