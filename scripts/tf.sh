#!/usr/bin/env bash
set -euo pipefail

COMMAND="${1:-help}"
ENVIRONMENT="${2:-dev}"

TF_DIR="environments/${ENVIRONMENT}"

case "${COMMAND}" in
  init)
    terraform -chdir="${TF_DIR}" init
    ;;
  fmt)
    terraform fmt -recursive
    ;;
  fmt-check)
    terraform fmt -recursive -check
    ;;
  validate)
    terraform -chdir="${TF_DIR}" validate
    ;;
  plan)
    terraform -chdir="${TF_DIR}" plan
    ;;
  apply)
    terraform -chdir="${TF_DIR}" apply
    ;;
  destroy)
    terraform -chdir="${TF_DIR}" destroy
    ;;
  *)
    echo "Usage: ./scripts/tf.sh {init|fmt|fmt-check|validate|plan|apply|destroy} [dev|prod]"
    exit 1
    ;;
esac
