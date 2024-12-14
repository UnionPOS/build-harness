#!/usr/bin/env bash

# AWS Lambda functions
function lambda_invoke() {
  local invocation_type="RequestResponse"
  local log_type="Tail"
  local function_name="$1"
  local payload="$2"
  local region="${AWS_REGION:-"us-west-2"}"
  local results_file="lambda_invoke_result"

  # Detect if the processor is ARM (includes Apple Silicon like M1, M2, M3)
  if [[ "$(uname -m)" == "arm64" || "$(uname -m)" == "aarch64" ]]; then
    result="$(aws lambda invoke \
      --invocation-type "$invocation_type" \
      --function-name "$function_name" \
      --region "$region" \
      --log-type "$log_type" \
      --cli-binary-format raw-in-base64-out \
      --payload "$payload" \
      "$results_file")"
  else
    result="$(aws lambda invoke \
      --invocation-type "$invocation_type" \
      --function-name "$function_name" \
      --region "$region" \
      --log-type "$log_type" \
      --payload "$payload" \
      "$results_file")"
  fi

  if [[ -n ${DECODE:-} ]]
  then
    echo "#######################################################################"
    echo "StatusCode: $(echo "$result" | jq .StatusCode)"
    echo "LogResult: "
    echo "$(echo "$result" | jq -r .LogResult | base64 --decode)"
    echo "#######################################################################"
  fi

  cat "$results_file" | jq
  rm "$results_file"
}
export -f lambda_invoke
