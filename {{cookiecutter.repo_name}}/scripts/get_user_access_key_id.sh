#!/bin/bash

IAM_USER_NAME="$1"
[[ -z "${IAM_USER_NAME}" ]] && echo "Error: IAM user name must be passed as first argument" && exit 10

terraform -chdir="terraform/{{ cookiecutter.__environment_lower }}" show -json | \
  jq --arg iam_user_name "${IAM_USER_NAME}" \
    --raw-output '
        .values.root_module.child_modules
      | map(select(.address == "module.admin_user_group"))[0].resources
      | map(select(
          .type == "aws_iam_access_key" and
          .values.user == $iam_user_name
        ))[0].values.id
    '
