#---
# EKS cluster
# Note: https://thinklumo.com/blue-green-node-deployment-kubernetes-eks-terraform/
#---

locals {
  cluster_name = "kubernetes-${var.environment}-${var.region}"

  worker_groups = [
    {
      name                  = "k8s-worker-blue"
      ami_id                = "ami-0dc5bf48daa40eb35"
      asg_desired_capacity  = "0"
      asg_max_size          = "0"
      asg_min_size          = "0"
      autoscaling_enabled   = true
      protect_from_scale_in = true
      instance_type         = "m5.large"
      root_volume_size      = "100"
      subnets               = "${join(",", data.terraform_remote_state.vpc.private_subnets)}"
      additional_userdata   = "aws s3 cp --recursive s3://audisp-json/ /tmp && sudo rpm -i /tmp/audisp-json-2.2.5-1.x86_64-amazon.rpm && sudo mv /tmp/audisp-json.conf /etc/audisp/audisp-json.conf && sudo service auditd restart && sudo yum install -y amazon-ssm-agent && sudo systemctl start amazon-ssm-agent"
    },
    {
      name                  = "k8s-worker-green"
      ami_id                = "ami-0dc5bf48daa40eb35"
      asg_desired_capacity  = "2"
      asg_max_size          = "10"
      asg_min_size          = "2"
      autoscaling_enabled   = true
      protect_from_scale_in = true
      instance_type         = "m5.large"
      root_volume_size      = "100"
      subnets               = "${join(",", data.terraform_remote_state.vpc.private_subnets)}"
      additional_userdata   = "aws s3 cp --recursive s3://audisp-json/ /tmp && sudo rpm -i /tmp/audisp-json-2.2.5-1.x86_64-amazon.rpm && sudo mv /tmp/audisp-json.conf /etc/audisp/audisp-json.conf && sudo service auditd restart && sudo yum install -y amazon-ssm-agent && sudo systemctl start amazon-ssm-agent"
    },
  ]

  tags = {
    "Environment" = "${var.environment}"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "2.3.1"

  cluster_name          = "${local.cluster_name}"
  cluster_version       = "1.13"
  subnets               = ["${data.terraform_remote_state.vpc.private_subnets}"]
  vpc_id                = "${data.terraform_remote_state.vpc.vpc_id}"
  worker_groups         = "${local.worker_groups}"
  worker_group_count    = "2"
  tags                  = "${local.tags}"
  write_kubeconfig      = "false"
  write_aws_auth_config = "false"
  manage_aws_auth       = "false"
}
