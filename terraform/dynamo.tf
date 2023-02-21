resource "aws_dynamodb_table" "client_application_table" {
  name         = var.client_application_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "client_id"


  attribute {
    name = "client_id"
    type = "S"
  }

  tags = merge(map("Name" , var.client_application_table_name), var.common_resource_tags)
}

resource "aws_dynamodb_table" "account_table" {
  name         = var.account_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user_name"

  attribute {
    name = "user_name"
    type = "S"
  }

  tags = merge(map("Name" , var.account_table_name), var.common_resource_tags)
}

resource "aws_dynamodb_table" "role_table" {
  name         = var.role_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "role_name"

  attribute {
    name = "role_name"
    type = "S"
  }

  tags = merge(map("Name" , var.role_table_name), var.common_resource_tags)
}

resource "aws_dynamodb_table" "account_role_table" {
  name         = var.account_role_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user_name"
  range_key    = "role_name"

  attribute {
    name = "role_name"
    type = "S"
  }

  attribute {
    name = "user_name"
    type = "S"
  }

  tags = merge(map("Name" , var.account_role_table_name), var.common_resource_tags)
}

resource "aws_dynamodb_table" "ticket_table" {
  name         = var.mail_verification_ticket_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ticket"

  attribute {
    name = "ticket"
    type = "S"
  }
  attribute {
    name = "ttl"
    type = "N"
  }

  ttl {
    attribute_name = "ttl"
  }

  tags = merge(map("Name" , var.mail_verification_ticket_table_name), var.common_resource_tags)
}

resource "aws_dynamodb_table" "mfa_account_methods" {
  name         = var.mfa_account_methods_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user_name"
  range_key    = "mfa_method"

  attribute {
    name = "user_name"
    type = "S"
  }
  attribute {
    name = "mfa_method"
    type = "S"
  }

  tags = merge(map("Name" , var.mfa_account_methods_table_name), var.common_resource_tags)
}

resource "aws_dynamodb_table" "mfa_keys" {
  name         = var.mfa_keys_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "key_id"

  attribute {
    name = "key_id"
    type = "S"
  }

  tags = merge(map("Name" , var.mfa_keys_table_name), var.common_resource_tags)
}

resource "aws_dynamodb_table" "signature_keys" {
  name         = var.signature_keys_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "key_id"

  attribute {
    name = "key_id"
    type = "S"
  }

  tags = merge(map("Name" , var.signature_keys_table_name), var.common_resource_tags)
}