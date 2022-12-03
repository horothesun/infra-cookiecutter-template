# required parameters

variable "account_id" {
  description = "The AWS account ID to deploy to."
  type        = string
}

variable "name" {
  description = "The bucket's name."
  type        = string
}

# optional parameters

variable "force_destroy" {
  description = "If set to `true`, the bucket will be deleted even if not empty."
  type        = bool
  default     = false
}

variable "versioning_status" {
  description = "If set to `Enabled`, the bucket will keep its objects' revisions."
  type        = string
  default     = "Disabled"
}

variable "encryption_at_rest_enabled" {
  description = "If set to `true`, it enables objects encryption at-rest (KMS-based: recurring costs)."
  type        = bool
  default     = true
}

variable "object_lock_enabled" {
  description = "If set to `true`, the bucket will lock its objects, preventing their deletion or overriding."
  type        = bool
  default     = false
}

variable "with_policy" {
  description = "If set to `true`, the bucket will be created with a bucket policy."
  type        = bool
  default     = false
}

variable "name_tag" {
  description = "The name tag to set for the S3 bucket."
  type        = string
  default     = "Test-Bucket"
}

variable "environment_tag" {
  description = "The environment tag to set for the S3 bucket."
  type        = string
  default     = "Test"
}
