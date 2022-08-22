resource "aws_ecr_lifecycle_policy" "foopolicy" {
  repository = var.registry_name

  policy = jsonencode({
    rules : [
      {
        rulePriority : 1,
        description : "Expire images older than 14 days",
        selection : {
          tagStatus : "untagged",
          countType : "sinceImagePushed",
          countUnit : "days",
          countNumber : 7
        },
        action : {
          type : "expire"
        }
      }
    ]
  })
}
