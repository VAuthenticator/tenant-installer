resource "aws_iam_user" "vauthenticator" {
  name = var.username
  path = var.path

  tags = merge(map("Name", var.username), var.common_resource_tags)
}


resource "aws_iam_user_policy_attachment" "_dynamo_policy-attach" {
  user       = aws_iam_user.vauthenticator.name
  policy_arn = aws_iam_policy.dynamo_policy.arn
}

resource "aws_iam_policy" "dynamo_policy" {
  name = "dynamodb_${var.username}_policy"
  path = var.path

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

data "aws_iam_policy_document" "dynamo_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.vauthenticator.arn]
    }

    actions = [
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:Query"
    ]

    resources = [
      aws_dynamodb_table.client_application_table.arn,
      aws_dynamodb_table.account_table.arn,
      aws_dynamodb_table.role_table.arn,
      aws_dynamodb_table.account_role_table.arn,
      aws_dynamodb_table.ticket_table.arn,
      aws_dynamodb_table.mfa_account_methods.arn,
      aws_dynamodb_table.mfa_keys.arn,
      aws_dynamodb_table.signature_keys.arn
    ]
  }
}