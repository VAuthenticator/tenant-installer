resource "aws_dynamodb_table" "client_application_table" {
  name         = var.client_application_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "client_id"


  attribute {
    name = "client_id"
    type = "S"
  }

  tags = {
    Name        = var.client_application_table_name
    Environment = var.environment
  }
}

resource "aws_dynamodb_table" "account_table" {
  name         = var.account_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user_name"

  attribute {
    name = "user_name"
    type = "S"
  }


  tags = {
    Name        = var.account_table_name
    Environment = var.environment
  }
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

  tags = {
    Name        = var.account_role_table_name
    Environment = var.environment
  }
}

resource "aws_dynamodb_table" "account_mfa_methods_table" {
  name         = var.account_mfa_methods_table_name
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

  tags = {
    Name        = var.account_mfa_methods_table_name
    Environment = var.environment
  }
}


resource "aws_dynamodb_table" "role_table" {
  name         = var.role_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "role_name"

  attribute {
    name = "role_name"
    type = "S"
  }


  tags = {
    Name        = var.role_table_name
    Environment = var.environment
  }
}

resource "aws_dynamodb_table" "mfa_keys_table" {
  name         = var.mfa_keys_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key    = "key_id"

  attribute {
    name = "key_id"
    type = "S"
  }

  tags = {
    Name        = var.mfa_keys_table
    Environment = var.environment
  }
}

resource "aws_dynamodb_table" "signature_keys_table" {
  name         = var.signature_keys_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key    = "key_id"

  attribute {
    name = "key_id"
    type = "S"
  }

  tags = {
    Name        = var.signature_keys_table
    Environment = var.environment
  }
}

resource "aws_dynamodb_table" "ticket_table" {
  name         = var.ticket_table_name
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

  tags = {
    Name        = var.ticket_table_name
    Environment = var.environment
  }
}