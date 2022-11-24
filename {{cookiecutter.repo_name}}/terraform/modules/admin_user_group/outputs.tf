output "{{ cookiecutter.__new_admin_user_tf }}_password" {
  value     = aws_iam_user_login_profile.{{ cookiecutter.__new_admin_user_tf }}.password
  sensitive = true
}
