#!/usr/bin/env bash
# shellcheck disable=SC2034

# Colors
export UI_ESC_SEQ="\x1b["
export UI_C_RESET="${UI_ESC_SEQ}39;49;00m"
export UI_C_RED="${UI_ESC_SEQ}31;01m"
export UI_C_GREEN="${UI_ESC_SEQ}32;01m"
export UI_C_YELLOW="${UI_ESC_SEQ}33;01m"
export UI_C_BLUE="${UI_ESC_SEQ}34;01m"
export UI_C_MAGENTA="${UI_ESC_SEQ}35;01m"
export UI_C_CYAN="${UI_ESC_SEQ}36;01m"

export BANNER='
        ___           ___                       ___           ___
       /\__\         /\__\          ___        /\  \         /\__\
      /:/  /        /::|  |        /\  \      /::\  \       /::|  |
     /:/  /        /:|:|  |        \:\  \    /:/\:\  \     /:|:|  |
    /:/  /  ___   /:/|:|  |__      /::\__\  /:/  \:\  \   /:/|:|  |__
   /:/__/  /\__\ /:/ |:| /\__\  __/:/\/__/ /:/__/ \:\__\ /:/ |:| /\__\
   \:\  \ /:/  / \/__|:|/:/  / /\/:/  /    \:\  \ /:/  / \/__|:|/:/  /
    \:\  /:/  /      |:/:/  /  \::/__/      \:\  /:/  /      |:/:/  /
     \:\/:/  /       |::/  /    \:\__\       \:\/:/  /       |::/  /
      \::/  /        /:/  /      \/__/        \::/  /        /:/  /
       \/__/         \/__/                     \/__/         \/__/
  '

################################################################################
# TUI Functions
################################################################################

function ui_action() {
  local -r msg="${1:-}"
  (>&2 echo -e "\n${UI_C_YELLOW}[action]:${UI_C_RESET}\n ⇒ ${msg} ...")
}

function ui_banner() {
  TERM=linux clear
  (>&2 echo -e "${UI_C_GREEN}${BANNER}${UI_C_RESET}")
}

function ui_bot() {
  local -r msg="${1:-}"
  (>&2 echo -e "\n${UI_C_GREEN}\[._.]/${UI_C_RESET} - ${msg}")
}

function ui_bot_confirm() {
  local -r msg="${1:-}"
  (>&2 echo -e "\n${UI_C_GREEN}\[._.]/${UI_C_RESET} - ${msg}")
  info "Press any key to continue."
  # shellcheck disable=SC2162
  read
}

function ui_die() {
  (>&2 echo "$@")
  exit 1
}

function ui_error() {
  local -r msg="${1:-}"
  (>&2 echo -e "\a${UI_C_RED}[error]${UI_C_RESET} ${msg}")
}

function ui_info() {
  local -r msg="${1:-}"
  (>&2 echo -e "${UI_C_GREEN}[info]${UI_C_RESET} ${msg}")
}

function ui_line() {
  (>&2 echo -e "------------------------------------------------------------------------------------")
}

function ui_ok() {
  local -r msg="${1:-}"
  (>&2 echo -e "${UI_C_GREEN}[ok]${UI_C_RESET} ${msg}")
}

function ui_running() {
  local -r msg="${1:-}"
  (>&2 echo -en "${UI_C_YELLOW} ⇒ ${UI_C_RESET} ${msg}:")
}

function ui_warn() {
  local -r msg="${1:-}"
  (>&2 echo -e "${UI_C_YELLOW}[warning]${UI_C_RESET} ${msg}")
}
