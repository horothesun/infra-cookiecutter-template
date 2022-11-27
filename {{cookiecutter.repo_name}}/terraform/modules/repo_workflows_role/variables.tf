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

variable "allowed_statements" {
  description = "GitHub workflow role allowed actions and roles."
  type = set(object({
    sid       = string
    actions   = list(string)
    resources = list(string)
  }))
}
