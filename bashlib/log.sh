#!/usr/bin/env bash

if [ -z "${LOG_VERBOSITY-}" ]; then
  export LOG_VERBOSITY=3
fi

### verbosity levels
log_lvl_always=0
log_lvl_fatal=1
log_lvl_error=2
log_lvl_warning=3
log_lvl_notice=4
log_lvl_info=5
log_lvl_debug=6

# Log the given message at the given level.
# All logs are written to stderr with a timestamp.
function log {
  local -r shown_at="$1"
  local -r level="$2"
  local -r message="$3"
  local -r timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  local -r script_name="$(basename "$0")"

  if [ "$LOG_VERBOSITY" -ge "$shown_at" ]; then
    >&2 echo -e "${timestamp} [${level}] [$script_name] ${message}"
  fi
}

# show log message regardless of verbosity level
function log_always() {
  local -r message="$1"
  log $log_lvl_always "" "$message"
}

# Log the given message at CRITICAL level.
function log_fatal() {
  local -r message="$1"
  log $log_lvl_fatal "FATAL" "$message"
}

# Log the given message at ERROR level.
function log_error() {
  local -r message="$1"
  log $log_lvl_error "ERROR" "$message"
}

# Log the given message at WARN level.
function log_warning() {
  local -r message="$1"
  log $log_lvl_warning "WARNING" "$message"
}

# Log the given message at NOTICE level.
function log_notice() {
  local -r message="$1"
  log $log_lvl_notice "NOTICE" "$message"
}

# Log the given message at INFO level
function log_info() {
  local -r message="$1"
  log $log_lvl_info "INFO" "$message"
}

# Log the given message at DEBUG level.
function log_debug() {
  local -r message="$1"
  log $log_lvl_debug "DEBUG" "$message"
}

# iterate vars and log at debug level
function log_dumpvar() {
  # shellcheck disable=SC2068
  for var in $@
  do
    debug "$var=${!var}"
  done
}



