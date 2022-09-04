resource "aws_ssm_parameter" "ecs_task_ssm" {
  name  = "${var.service_name}-ecs-task-ssm"
  type  = "String"
  value = "${data.aws_caller_identity.current.account_id}-ssm"
}