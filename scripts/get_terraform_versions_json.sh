#!/bin/bash

TERRAFORM_PROD_DIR="$1"
[[ -z "${TERRAFORM_PROD_DIR}" ]] && echo '{ "error": "TERRAFORM_PROD_DIR must be passed as first argument" }' && exit 10

terraform-config-inspect --json "${TERRAFORM_PROD_DIR}" | \
  jq --monochrome-output --compact-output '{
    "terraform_version": .required_core[0],
    "terraform_aws_version": .required_providers.aws.version_constraints[0]
  }'
