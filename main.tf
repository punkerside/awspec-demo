resource "random_uuid" "main" {}

resource "aws_s3_bucket" "main" {
  bucket        = random_uuid.main.result
  tags          = var.tags
  force_destroy = var.force_destroy
  acl           = var.acl
}