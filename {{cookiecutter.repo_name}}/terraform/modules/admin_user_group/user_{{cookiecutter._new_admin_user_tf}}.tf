resource "aws_iam_user" "{{ cookiecutter._new_admin_user_tf }}" {
  name = "{{ cookiecutter.new_admin_user }}"
}

resource "aws_iam_user_group_membership" "{{ cookiecutter._new_admin_user_tf }}" {
  user   = aws_iam_user.{{ cookiecutter._new_admin_user_tf }}.name
  groups = [aws_iam_group.administrators.name]
}

resource "aws_iam_user_login_profile" "{{ cookiecutter._new_admin_user_tf }}" {
  user                    = aws_iam_user.{{ cookiecutter._new_admin_user_tf }}.name
  password_reset_required = false
}

resource "aws_iam_access_key" "{{ cookiecutter._new_admin_user_tf }}" {
  user = aws_iam_user.{{ cookiecutter._new_admin_user_tf }}.name
}
