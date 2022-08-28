// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids
// The aws_subnet_ids data source has been deprecated and will be removed in a future version. Use the aws_subnets data source instead.
// ids - A list of all the subnet ids found. ex. data.aws_subnets.public.ids

data "aws_caller_identity" "current" {
}

data "aws_vpc" "main" {
  tags = {
    Name = "ci-cd-vpc"
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  tags = {
    Tier = "public"
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  tags = {
    Tier = "private"
  }
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