#!/bin/bash

[[ -z "${TERRAFORM_VERSION}" ]] && echo "Error: TERRAFORM_VERSION must be defined" && exit 10
[[ -z "${TERRAFORM_AWS_VERSION}" ]] && echo "Error: TERRAFORM_AWS_VERSION must be defined" && exit 20

ex -u NONE \
  -c "%s/<TERRAFORM_VERSION>/${TERRAFORM_VERSION}/" \
  -c "%s/<TERRAFORM_AWS_VERSION>/${TERRAFORM_AWS_VERSION}/" \
  -c "wq" "cookiecutter.json"
