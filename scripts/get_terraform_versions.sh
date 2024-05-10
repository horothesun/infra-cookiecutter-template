#!/bin/bash

[[ -z "${TERRAFORM_PROD_DIR}" ]] && echo "Error: TERRAFORM_PROD_DIR must be defined" && exit 10

TF_CONFIG_INSPECT_CMD="terraform-config-inspect"

echo "Chech if '${TF_CONFIG_INSPECT_CMD}' exists..."
command -v "${TF_CONFIG_INSPECT_CMD}"
# echo "'${TF_CONFIG_INSPECT_CMD}' found!"

TF_CONFIG_INSPECTION=$(
  "${TF_CONFIG_INSPECT_CMD}" --json "${TERRAFORM_PROD_DIR}" | \
    jq --compact-output '.'
)

TERRAFORM_VERSION=$(
  echo "${TF_CONFIG_INSPECTION}" | \
    jq --raw-output '.required_core[0] | select(. != null)'
)
TERRAFORM_AWS_VERSION=$(
  echo "$TF_CONFIG_INSPECTION" | \
    jq --raw-output '.required_providers.aws.version_constraints[0] | select(. != null)'
)

TF_DIAGNOSTICS=$(
  echo "${TF_CONFIG_INSPECTION}" | \
    jq --compact-output '.diagnostics | select(. != null)'
)
echo "TF_DIAGNOSTICS: ${TF_DIAGNOSTICS}"

if [[ -z "${TERRAFORM_VERSION}" ]]; then
  echo "Diagnostics:"
  echo "${TF_DIAGNOSTICS}" | jq '.'
  exit 123
fi

echo "TERRAFORM_VERSION: ${TERRAFORM_VERSION}"
export TERRAFORM_VERSION

echo "TERRAFORM_AWS_VERSION: ${TERRAFORM_AWS_VERSION}"
export TERRAFORM_AWS_VERSION
