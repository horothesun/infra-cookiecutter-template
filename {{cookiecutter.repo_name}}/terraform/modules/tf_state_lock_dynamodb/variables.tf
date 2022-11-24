# optional parameters

variable "name_tag" {
  description = "The name tag to set for the DynamoDB table."
  type        = string
  default     = "Test-Table"
}

variable "environment_tag" {
  description = "The environment tag to set for the DynamoDB table."
  type        = string
  default     = "Test"
}
