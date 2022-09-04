resource "aws_ecs_service" "ecs_service" {
  name            = "${var.service_name}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.service_task_fargate.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = var.service_name
    container_port   = 3000
  }

  network_configuration {
    subnets          = aws_subnet.private.*.id
    # assign_public_ip = false
    security_groups  = [aws_security_group.ecs_tasks.id]
  }

  depends_on = [aws_lb_listener.http]
}