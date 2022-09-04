data "aws_caller_identity" "current" {
}

data "aws_iam_policy_document" "cloudwatch_logs_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.containers.arn}:*"
    ]
  }
}

data "aws_availability_zones" "available_zones" {
  state = "available"
}
