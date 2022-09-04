resource "aws_secretsmanager_secret" "ecs_task_secret_manager" {
  name = "${var.service_name}-ecs-secret-manager"
}