resource "aws_iam_role" "cloudwatch_fetch_metrics" {
  name               = "cloudwatch_fetch_metrics"
  path               = "/itsre/"
  assume_role_policy = "${data.aws_iam_policy_document.allow_assume_role.json}"
}

data "aws_iam_policy_document" "allow_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::517826968395:root"]
    }
  }
}

resource "aws_iam_role_policy" "allow_fetch_cloudwatch_metrics" {
  name   = "allow_fetch_cloudwatch_metrics"
  role   = "${aws_iam_role.cloudwatch_fetch_metrics.id}"
  policy = "${data.aws_iam_policy_document.allow_fetch_cloudwatch_metrics.json}"
}

data "aws_iam_policy_document" "allow_fetch_cloudwatch_metrics" {
  statement {
    actions = [
      "cloudwatch:Describe*",
      "cloudwatch:GetMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

output "iam_role_arn" {
  value       = "${aws_iam_role.cloudwatch_fetch_metrics.arn}"
  description = "ARN of the user allowed to fetch metrics."
}
