module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.7.0"

  bucket                  = var.document_s3_bucket_name
  acl                     = "private"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  force_destroy = true

  tags = merge(map("Name" , var.document_s3_bucket_name), var.common_resource_tags)
}
