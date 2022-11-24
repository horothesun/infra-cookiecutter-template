output "id" {
  description = "Bucket's name (unique world-wide)."
  value       = aws_s3_bucket.bucket.id
}

output "arn" {
  value = aws_s3_bucket.bucket.arn
}
