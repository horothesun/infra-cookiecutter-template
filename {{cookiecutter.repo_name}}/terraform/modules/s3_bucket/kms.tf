resource "aws_kms_key" "server_side_encryption_key" {
  count = var.encryption_at_rest_enabled ? 1 : 0

  description             = "This key is used to encrypt bucket objects."
  deletion_window_in_days = 10
}
