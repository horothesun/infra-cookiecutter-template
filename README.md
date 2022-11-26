# AWS infrastucture bootstrap template

[![CI](https://github.com/horothesun/infra-cookiecutter-template/actions/workflows/ci.yml/badge.svg)](https://github.com/horothesun/infra-cookiecutter-template/actions/workflows/ci.yml)

Can't be bothered to go through the initial setup necessary
to terraform your AWS account? 🙄

Fear no more!

This template will give you a minimal Terraform codebase with

- 👤 non-`root` IAM admin user
- 💾 remote Terraform state on S3 (with DynamoDB locking)
- ⚡ CI workflow to continously apply state changes,
  displaying Terraform plans as PR comments
- 🔐 "AWS Open ID Connect for GitHub" identity provider and
  "GitHub workflows AWS role" to securely login the CI to your AWS account.

Just generate the project and follow the instructions you'll find in the `README`.

## Requirements

- Cookiecutter ([install](https://cookiecutter.readthedocs.io/en/latest/installation.html))

## Generate new project

```bash
cookiecutter https://github.com/horothesun/infra-cookiecutter-template
cd <repo_name>
```
