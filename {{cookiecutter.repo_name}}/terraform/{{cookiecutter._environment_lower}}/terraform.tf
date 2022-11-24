terraform {
  required_version = "1.3.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=4.40.0"
    }
  }

  backend "s3" {
    key            = "terraform.tfstate"
    encrypt        = true
    bucket         = "tf-state-{{ cookiecutter.__tf_state_bucket_postfix_uuid }}"
    dynamodb_table = "tf-state-lock"
  }
}
