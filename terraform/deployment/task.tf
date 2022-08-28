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
    image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-2.amazonaws.com/${var.service_name}-pipeline:${var.latest_image_tag}"
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
