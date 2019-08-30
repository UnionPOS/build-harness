#!/usr/bin/env bash

function mapdaemon() {
  daemon=$1
  case $daemon in
    'api')
      fullname="union-pos-api"
      ;;
    'celery')
      fullname="union-celeryrun"
      ;;
    'couch')
      fullname="union-couch-worker"
      ;;
    'couchworker')
      fullname="union-couch-worker"
      ;;
    'clustermon')
      fullname="clustermon"
      ;;
    'foundry')
      fullname="union-pos-foundry"
      ;;
    'indexmon')
      fullname="indexmon"
      ;;
    'mdm')
      fullname="union-micromdm"
      ;;
    'mdmworker')
      fullname="union-mdm-worker"
      ;;
    'seqmon')
      fullname="union-seqmon"
      ;;
    'sqs')
      fullname="union-sqs-pipe"
      ;;
    'sqsworker')
      fullname="union-sqs-pipe"
      ;;
    'sync')
      fullname="sync_gateway"
      ;;
    'syncgateway')
      fullname="sync_gateway"
      ;;
    *)
      (>&2 echo "unrecognized daemon $daemon")
      exit 1
      ;;
  esac
  echo "$fullname"
}

function mapservicegroup() {
  servicegroup=$1
  case $servicegroup in
    'api'|'celery'|'union-pos-api'|'union-celeryrun')
      servicegroup="api"
      ;;
    'build')
      servicegroup="build"
      ;;
    'couchbase'|'clustermon'|'indexmon')
      servicegroup="couchbase"
      ;;
    'couchbasexdcr')
      servicegroup='couchbasexdcr'
      ;;
    'couchworker'|'union-couch-worker')
      servicegroup="couchworker"
      ;;
    'foundry'|'union-pos-foundry')
      servicegroup="foundry"
      ;;
    'sqsworker'|'seqmon'|'union-sqs-pipe')
      servicegroup="sqsworker"
      ;;
    'syncgateway')
      servicegroup="syncgateway"
      ;;
    *)
      servicegroup=""
      ;;
  esac

  echo "$servicegroup"
}
