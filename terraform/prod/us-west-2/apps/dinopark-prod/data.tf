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

data "aws_security_group" "es-allow-https" {
  id = "sg-08f1fb74db97a268e"
}

data "aws_route53_zone" "sso_mozilla_com" {
  name = "sso.mozilla.com."
}

data "aws_elb" "k8s-elb" {
  name = "af3ef016b807c11e9976f06f807dee91"
}
