resource "aws_ecs_service" "ecs_service" {
  name            = "${var.service_name}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.service_task_fargate.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  for_each        = toset(data.aws_subnets.public.ids)

  network_configuration {
    subnets          = each.value
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_tasks.id]
  }
}

resource "aws_security_group" "ecs_tasks" {
  name   = "${var.service_name}-sg-ecs-tasks"
  vpc_id = data.aws_vpc.main.id
  ingress {
    protocol         = "tcp"
    from_port        = 3000
    to_port          = 3000
    cidr_blocks      = [data.aws_vpc.main.cidr_block]
  }
  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
