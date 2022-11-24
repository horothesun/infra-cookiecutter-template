#!/bin/bash

PASS_ENTRY_NAME="$1"

if [[ -z "${PASS_ENTRY_NAME}" ]] ; then
  echo "Error: 'pass' entry name must be passed as first argument"
else
  AWS_ACCESS_KEY_ID=$(pass "${PASS_ENTRY_NAME}" | grep "Access Key ID" | grep -o "[^ ]*$")
  AWS_SECRET_ACCESS_KEY=$(pass "${PASS_ENTRY_NAME}" | grep "Secret Access Key" | grep -o "[^ ]*$")
  IAM_USER_NAME=$(pass "${PASS_ENTRY_NAME}" | grep "login" | grep -o "[^ ]*$")

  export AWS_REGION="{{ cookiecutter.aws_region }}"
  export AWS_DEFAULT_REGION="{{ cookiecutter.aws_region }}"
  export AWS_ACCESS_KEY_ID
  export AWS_SECRET_ACCESS_KEY
  export IAM_USER_NAME
fi
