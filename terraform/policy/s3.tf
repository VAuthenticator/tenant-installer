data "aws_s3_bucket" "document_bucket" {
  bucket = var.document_s3_bucket_name
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = data.aws_s3_bucket.document_bucket.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_iam_user.vauthenticator.arn]
    }

    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::${var.document_s3_bucket_name}",
      "arn:aws:s3:::${var.document_s3_bucket_name}/*"
    ]
  }
}