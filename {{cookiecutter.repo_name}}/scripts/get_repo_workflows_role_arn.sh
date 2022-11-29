#!/bin/bash

GITHUB_ORG="$1"
REPO_NAME="$2"

[[ -z "${GITHUB_ORG}" ]] && echo "Error: GitHub organisation/user name must be passed as first argument" && exit 10
[[ -z "${REPO_NAME}" ]] && echo "Error: GitHub repo name must be passed as second argument" && exit 20

GITHUB_ORG_TF="${GITHUB_ORG//-/_}"
REPO_NAME_TF="${REPO_NAME//-/_}"

terraform -chdir="terraform/prod" show -json | \
  jq --raw-output \
    --arg githubOrgTf "${GITHUB_ORG_TF}" \
    --arg repoNameTf "${REPO_NAME_TF}" '
      .values.root_module.child_modules
    | map(select(.address == "module.\($githubOrgTf)_\($repoNameTf)_workflows_role"))[0].resources
    | map(select(.address == "module.\($githubOrgTf)_\($repoNameTf)_workflows_role.aws_iam_role.repo_workflows"))[0].values.arn
  '
