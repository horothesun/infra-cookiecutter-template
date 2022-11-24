resource "aws_iam_group" "{{ cookiecutter._new_admin_group_name_tf }}" {
  name = "{{ cookiecutter.new_admin_group_name }}"
  path = "/"
}

data "aws_iam_policy" "administrator_access" {
  name = "AdministratorAccess"
}

resource "aws_iam_group_policy_attachment" "{{ cookiecutter._new_admin_group_name_tf }}" {
  group      = aws_iam_group.{{ cookiecutter._new_admin_group_name_tf }}.name
  policy_arn = data.aws_iam_policy.administrator_access.arn
}

data "aws_iam_policy_document" "administrator_allow_list" {
  statement {
    sid    = "AllowAllRequiredPermissions"
    effect = "Allow"
    not_actions = [
      "iam:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "administrator_allow_list" {
  name        = "administrator-allow-list"
  path        = "/"
  description = "Policy to allow all required permissions"
  policy      = data.aws_iam_policy_document.administrator_allow_list.json
}

resource "aws_iam_group_policy_attachment" "administrator_allow_list" {
  group      = aws_iam_group.{{ cookiecutter._new_admin_group_name_tf }}.name
  policy_arn = aws_iam_policy.administrator_allow_list.arn
}
