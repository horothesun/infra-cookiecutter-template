# required parameters

variable "oidc_github_arn" {
  description = "ARN of AWS OIDC for GitHub"
  type        = string
}

variable "github_org" {
  description = "GitHub organisation name"
  type        = string
}

variable "repo_name" {
  description = "Repository name"
  type        = string
}

variable "allowed_actions" {
  description = "GitHub workflow role allowed AWS actions"
  type        = list(string)
}

variable "resources" {
  description = "GitHub workflow role AWS actions' target resources"
  type        = list(string)
}
