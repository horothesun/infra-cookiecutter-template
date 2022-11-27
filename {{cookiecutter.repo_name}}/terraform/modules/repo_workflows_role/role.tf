locals {
  role_name = "${var.github_org}_${var.repo_name}_workflows"
}

resource "aws_iam_role" "repo_workflows" {
  name = local.role_name

  assume_role_policy = data.aws_iam_policy_document.repo_workflows_assume_role.json

  tags = {
    Owner = var.github_org
  }
}

data "aws_iam_policy_document" "repo_workflows_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_github_arn]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_org}/${var.repo_name}:*"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy_attachment" "repo_workflows" {
  name       = "${local.role_name}_allowed-actions"
  roles      = [aws_iam_role.repo_workflows.name]
  policy_arn = aws_iam_policy.repo_workflows.arn
}

resource "aws_iam_policy" "repo_workflows" {
  name   = "${local.role_name}_allowed-actions"
  policy = data.aws_iam_policy_document.repo_workflows_allowed_actions.json
}

data "aws_iam_policy_document" "repo_workflows_allowed_actions" {
  dynamic "statement" {
    for_each = var.allowed_statements
    content {
      sid       = statement.value.sid
      effect    = "Allow"
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}
