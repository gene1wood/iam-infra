#---
# Provider Configuration
#---

provider "aws" {
  region  = "us-west-2"
}

terraform {
  required_version = "~> 0.11"

  backend "s3" {
    bucket = "eks-terraform-shared-state"
    key    = "prod/us-west-2/apps/dinopark-prod/terraform.tfstate"
    region = "us-west-2"
  }
}
