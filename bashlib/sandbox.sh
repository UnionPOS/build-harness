#!/usr/bin/env bash

function git_clone_or_update() {
  if [ -d "$2/.git" ]; then
    action "update $1"
    ( cd "$2" || exit; git checkout master && git pull origin master && git submodule update --recursive > /dev/null 2>&1 )
    set +e
    ( cd "$2" || exit; git checkout develop && git pull origin develop && git submodule update --recursive > /dev/null 2>&1 )
    set -e
  else
    action "clone $1"
    git clone --recurse-submodules "$1" "$2" > /dev/null 2>&1
  fi
}

function list_containers() {
  echo "1. Couchbase"
  echo "2. MySQL"
  echo "3. Redis"
  echo "4. Syncgateway"
  echo "5. POS API"
  echo "6. POS Celery Worker"
  echo "7. POS Couch Worker"
  echo "8. POS Foundry"
  echo "9. POS Portal"
  echo "10. POS SQS Worker"
  echo "11. POS MDM Worker"
  echo "12. GoAWS"
  echo "13. FakeS3"
  echo "14. MicroMDM"
}

function instance_name_from_selection() {
  case "$1" in
    1) instance=couchbase.union
      ;;
    2) instance=mysql.union
      ;;
    3) instance=redis.union
      ;;
    4) instance=sync.union
      ;;
    5) instance=api.union
      ;;
    6) instance=celery.union
     ;;
    7) instance=couchworker.union
      ;;
    8) instance=foundry.union
      ;;
    9) instance=portal.union
     ;;
    10) instance=sqsworker.union
      ;;
    11) instance=mdmworker.union
      ;;
    12) instance=goaws.union
      ;;
    13) instance=fakes3.union
      ;;
    14) instance=micromdm.union
      ;;
    *)
      instance=""
      ;;
  esac
  echo "$instance"
}
