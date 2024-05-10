terraform {
  required_version = "{{ cookiecutter.terraform_version }}"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "{{ cookiecutter.terraform_aws_provider_version }}"
    }
  }

  backend "s3" {
    key            = "terraform.tfstate"
    encrypt        = true
    bucket         = "tf-state-{{ cookiecutter.__tf_state_bucket_postfix_uuid }}"
    dynamodb_table = "tf-state-lock"
  }
}
