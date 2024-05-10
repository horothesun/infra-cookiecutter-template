#!/bin/bash

[[ -z "${TERRAFORM_VERSION}" ]] && echo "Error: TERRAFORM_VERSION must be defined" && exit 10
[[ -z "${TERRAFORM_AWS_VERSION}" ]] && echo "Error: TERRAFORM_AWS_VERSION must be defined" && exit 20

COOKIECUTTER_JSON="$1"
[[ -z "${COOKIECUTTER_JSON}" ]] && echo "Error: COOKIECUTTER_JSON must be passed as first argument" && exit 100

ex -u NONE \
  -c "%s/<TERRAFORM_VERSION>/${TERRAFORM_VERSION}/" \
  -c "%s/<TERRAFORM_AWS_VERSION>/${TERRAFORM_AWS_VERSION}/" \
  -c "wq" "${COOKIECUTTER_JSON}"
