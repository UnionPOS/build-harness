#!/usr/bin/env bash

# AWS s3 functions

function s3_copy() {
  local FROM="$1"
  local TO="$2"

  aws s3 cp "$FROM" "$TO" --recursive
}
export -f s3_copy
