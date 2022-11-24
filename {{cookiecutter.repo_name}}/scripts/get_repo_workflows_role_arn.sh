#!/bin/bash

terraform -chdir="terraform/{{ cookiecutter.__environment_lower }}" show -json | \
  jq --raw-output '
      .values.root_module.child_modules
    | map(select(.address == "module.{{ cookiecutter.github_org }}_{{ cookiecutter.repo_name }}_workflows_role"))[0].resources
    | map(select(.address == "module.{{ cookiecutter.github_org }}_{{ cookiecutter.repo_name }}_workflows_role.aws_iam_role.repo_workflows"))[0].values.arn
  '
