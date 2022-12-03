data "aws_caller_identity" "current" {}

locals {
  environment = "{{ cookiecutter.__environment_lower }}"
  account_id  = data.aws_caller_identity.current.account_id
}

module "admin_user_group" {
  source = "../modules/admin_user_group"
}

module "terraform_state_bucket" {
  source = "../modules/s3_bucket"

  account_id                 = local.account_id
  name                       = "tf-state-{{ cookiecutter.__tf_state_bucket_postfix_uuid }}"
  force_destroy              = false
  versioning_status          = "Enabled"
  encryption_at_rest_enabled = false
  object_lock_enabled        = true
  with_policy                = true
  name_tag                   = "Main Terraform state bucket"
  environment_tag            = local.environment
}

module "terraform_state_lock_dynamodb" {
  source = "../modules/tf_state_lock_dynamodb"

  name_tag        = "DynamoDB Terraform state lock table"
  environment_tag = local.environment
}

module "oidc_github" {
  source = "../modules/oidc_github"
}

module "{{ cookiecutter.__github_org_tf }}_{{ cookiecutter.__repo_name_tf }}_workflows_role" {
  source = "../modules/repo_workflows_role"

  oidc_github_arn = module.oidc_github.arn
  github_org      = "{{ cookiecutter.github_org }}"
  repo_name       = "{{ cookiecutter.repo_name }}"
  allowed_statements = ([
    {
      sid = "TerraformApply"
      actions = [
        "apigateway:*",
        "cloudwatch:*",
        "dynamodb:*",
        "ec2:*",
        "ecr:*",
        "ecs:*",
        "iam:*",
        "kms:*",
        "lambda:*",
        "logs:*",
        "route53:*",
        "s3:*",
        "sts:GetCallerIdentity"
      ]
      resources = ["*"]
    }
  ])
}
