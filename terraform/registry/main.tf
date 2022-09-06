resource "aws_ecr_repository" "repository" {
  name                 = "${var.service_name}-pipeline"
  image_tag_mutability = "IMMUTABLE" // Default: MUTABLE, 동일한 태그를 사용하는 후속 이미지 푸시가 이미지 태그를 덮어쓰지 않도록 방지(IMMUTABLE)

  tags                 = {
    Name = "${var.service_name}-pipeline"
  }

  image_scanning_configuration {
    scan_on_push = false // 사용 중단 경고, 리포지토리 수준의 ScanOnPush 구성은 더 이상 사용되지 않으며 레지스트리 수준 스캔 필터로 대체
  }
}

output "registry_id" {
  description = "The account ID of the registry holding the repository."
  value = aws_ecr_repository.repository.registry_id
}

output "repository_name" {
  description = "The name of the repository."
  value = aws_ecr_repository.repository.name
}

output "repository_url" {
  description = "The URL of the repository."
  value = aws_ecr_repository.repository.repository_url
}
