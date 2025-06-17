resource "aws_ecr_repository" "engageiq" {
  name = "engageiq-demo"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  lifecycle {
    ignore_changes = [image_scanning_configuration]
  }

  tags = {
    Environment = var.environment
  }
}
