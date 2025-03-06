resource "aws_ecr_repository" "ECR_repo" {
  count = length(var.Component)
  name                 = "${var.project_name}-${var.Component[count.index]}"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
