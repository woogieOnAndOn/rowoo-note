resource "aws_ecs_task_definition" "service_task_fargate" {
  network_mode             = "awsvpc"
  family                   = var.service_name
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name  = var.service_name
    image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-2.amazonaws.com/${var.service_name}-pipeline:latest"
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        awslogs-group         = "/aws/ecs/${var.service_name}"
        awslogs-region        = "ap-northeast-2"
        awslogs-create-group  = "true"
        awslogs-stream-prefix = var.service_name
      }
    }
    portMappings = [{
      protocol      = "tcp"
      containerPort = 3000
      hostPort      = 3000
    }] }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.service_name}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.service_task_fargate.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  for_each        = toset(data.aws_subnets.private.ids)

  network_configuration {
    subnets          = each.value
    assign_public_ip = false
    security_groups  = [aws_security_group.ecs_tasks.id]
  }
}

resource "aws_security_group" "ecs_tasks" {
  name   = "${var.service_name}-sg-ecs-tasks"
  vpc_id = data.aws_vpc.main.id
  ingress {
    protocol    = "tcp"
    from_port   = 3000
    to_port     = 3000
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_cloudwatch_log_group" "containers" {
  name              = "/aws/ecs/${var.service_name}"
  retention_in_days = 7
  tags = {
    Terraform = "true"
    Name      = "cloudwatch-group-${var.service_name}"
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

resource "aws_iam_policy" "cloudwatch_logs_policy" {
  path   = "/ecs/task-role/"
  policy = data.aws_iam_policy_document.cloudwatch_logs_policy.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}
