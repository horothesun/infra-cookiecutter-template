# Infrastructure

[![CI](https://github.com/{{ cookiecutter.github_org }}/{{ cookiecutter.repo_name }}/actions/workflows/ci.yml/badge.svg)](https://github.com/{{ cookiecutter.github_org }}/{{ cookiecutter.repo_name }}/actions/workflows/ci.yml)

> IMPORTANT: this codebase contains sensitive data (e.g. admin user name).

## First-time setup

> Legend: 🤖 GitHub, 🌍 AWS web console, 💻 local machine.

- 🌍 Create a temporary access key for the `root` user ([reference](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html)).
- 💻 Login as `root` ([reference](#aws-cli-login%2Flogout)).
- 💻 Temporarily comment out `terraform`'s `s3` `backend` from
  `terraform/{{ cookiecutter.__environment_lower }}/terraform.tf`.
- 💻 Temporarily comment out the following modules from
  `terraform/{{ cookiecutter.__environment_lower }}/main.tf`
  - `terraform_state_bucket`
  - `terraform_state_lock_dynamodb`
  - `oidc_github`
  - `{{ cookiecutter.__github_org_tf }}_{{ cookiecutter.__repo_name_tf }}_workflows_role`
- 💻 Apply the `admin_user_group` module.
- 💻 Get your new non-`root` user's
  - password (`./scripts/get_user_password.sh "<IAM_USER_NAME>"`)
  - access key ID (`./scripts/get_user_access_key_id.sh "<IAM_USER_NAME>"`)
  - secret access key (`./scripts/get_user_secret_access_key.sh "<IAM_USER_NAME>"`)
- 🌍 Login with your new admin user (creating a new password) and
  activate a Virtual MFA device.
- 💻 Once the user has correctly logged-in for the first time (with a password update),
  set `aws_iam_user_login_profile.password_reset_required` value to `false`
  and apply it in order to reflect the actual state change.
- 🌍 Secure the `root` user by deleting its access key.
- 💻 Login with your newly created non-`root` admin user ([reference](#aws-cli-login%2Flogout)).
- 💻 Uncomment and apply the following modules from
  `terraform/{{ cookiecutter.__environment_lower }}/main.tf`
  - `terraform_state_bucket`
  - `terraform_state_lock_dynamodb`
- 💻 Uncomment and apply `terraform`'s `s3` `backend` from
  `terraform/{{ cookiecutter.__environment_lower }}/terraform.tf`.
- 💻 Uncomment and apply the following modules from
  `terraform/{{ cookiecutter.__environment_lower }}/main.tf`
  - `oidc_github`
  - `{{ cookiecutter.__github_org_tf }}_{{ cookiecutter.__repo_name_tf }}_workflows_role`
- 💻 Get the CI role ARN value by running `./scripts/get_repo_workflows_role_arn.sh`.
- 🤖 Set the GitHub Actions `{{ cookiecutter.__environment_upper }}_CI_ROLE_ARN`
  secret value with the previously retrieved one.
- ✅ Enjoy your new continously deployed infrastructure!

## AWS CLI login/logout

There are two types of login:

- _access key only_ and
- _access key + session token_.

The _access key only_ login populates the following environment variables

- `IAM_USER_NAME`
- `AWS_REGION`
- `AWS_DEFAULT_REGION`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

The _access key + session token_ login populates the same environment variables
as the _access key only_ login, with the addition of `AWS_SESSION_TOKEN`.

In order to login with the `root` user, perform an _access key only_ login.
To login with any other user, perform an _access key + session token_ login instead.

A [`pass`](https://www.passwordstore.org/)-based script is provided to perform
_access key only_ logins (`scripts/access_key_login_from_pass.sh`).

Example of `root` user [`pass`](https://www.passwordstore.org/)-based login

```bash
source scripts/logout.sh && \
  source scripts/access_key_login_from_pass.sh "<ROOT_USER_PASS_ENTRY>"
```

Example of non-`root` user [`pass`](https://www.passwordstore.org/)-based login

```bash
source scripts/logout.sh && \
  source scripts/access_key_login_from_pass.sh "<IAM_USER_PASS_ENTRY>" && \
  source scripts/mfa_login.sh "<MFA_OTP>"
```

> N.B.: in order to perform `mfa_login.sh`, it's necessary to perform an
> _access key only_ login first.

Example of logout

```bash
source scripts/logout.sh
```

## Utils

Check the current login environment variables with

```bash
env | grep -e "^AWS" -e "^IAM"
```

Get currently logged-in AWS user with

```bash
aws sts get-caller-identity | jq '.'
```

Apply Terraform formatting with

```bash
terraform fmt -recursive terraform/
```

Retrieve user password with

```bash
./scripts/get_user_password.sh "<IAM_USER_NAME>"
```

Retrieve user access key ID with

```bash
./scripts/get_user_access_key_id.sh "<IAM_USER_NAME>"
```

Retrieve user secret access key with

```bash
./scripts/get_user_secret_access_key.sh "<IAM_USER_NAME>"
```

Retrieve CI role ARN (`{{ cookiecutter.__environment_upper }}_CI_ROLE_ARN` secret value) with

```bash
./scripts/get_repo_workflows_role_arn.sh "{{ cookiecutter.github_org }}" "{{ cookiecutter.repo_name }}"
```

## Notes

- Upon creating a new user, start by setting
  `aws_iam_user_login_profile.password_reset_required` to `true`.
  Once the user has correctly logged-in for the first time and updated its password,
  `terraform apply` after updating the value to `false` in order to reflect the actual
  status change.
- AWS Actions, Resources and Context Keys [docs](https://docs.aws.amazon.com/service-authorization/latest/reference/reference_policies_actions-resources-contextkeys.html).
- Get all [AWS actions required by a Terraform command](https://stackoverflow.com/a/60542958/5210544):
  login with a full-permission user/role, then run

```bash
TF_CMD="..." # one of: init, plan, apply
TF_LOG=trace terraform -chdir="terraform/{{ cookiecutter.__environment_lower }}" "${TF_CMD}" &> "${TF_CMD}.log"
grep "DEBUG: Request" "${TF_CMD}.log"
```
