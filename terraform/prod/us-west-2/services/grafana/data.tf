data "aws_caller_identity" "current" {}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "eks-terraform-shared-state"
    key    = "prod/us-west-2/vpc/terraform.tfstate"
    region = "us-west-2"
  }
}

data "terraform_remote_state" "kubernetes" {
  backend = "s3"

  config {
    bucket = "eks-terraform-shared-state"
    key    = "prod/us-west-2/kubernetes/terraform.tfstate"
    region = "us-west-2"
  }
}

data "aws_route53_zone" "infra_iam" {
 name = "infra.iam.mozilla.com."
}

data "aws_elb" "k8s-elb" {
 name = "a8f6fd77d7afc11e9be090a6aa30f629"
}

