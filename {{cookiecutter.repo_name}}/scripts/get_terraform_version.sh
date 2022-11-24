#!/bin/bash

[[ -z "${TERRAFORM_{{ cookiecutter._environment_upper }}_DIR}" ]] && echo "Error: TERRAFORM_{{ cookiecutter._environment_upper }}_DIR must be defined" && exit 10

TF_CONFIG_INSPECT_CMD="terraform-config-inspect"

echo "Chech if '${TF_CONFIG_INSPECT_CMD}' exists..."
command -v "${TF_CONFIG_INSPECT_CMD}"
echo "'${TF_CONFIG_INSPECT_CMD}' found!"

TF_CONFIG_INSPECTION=$(
  "${TF_CONFIG_INSPECT_CMD}" --json "${TERRAFORM_{{ cookiecutter._environment_upper }}_DIR}" | \
    jq --compact-output '.'
)

TERRAFORM_VERSION=$(
  echo "${TF_CONFIG_INSPECTION}" | \
    jq --raw-output '.required_core[0] | select(. != null)'
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
