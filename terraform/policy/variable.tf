# tags variables
variable "common_resource_tags" {
  type = map(string)
}

# iam variables
variable "username" {
  type = string
}
variable "path" {
  type = string
}

# dynamodb variables
variable "client_application_table_name" {
  type = string
}
variable "account_table_name" {
  type = string
}
variable "role_table_name" {
  type = string
}
variable "account_role_table_name" {
  type = string
}
variable "keys_table_name" {
  type = string
}
variable "ticket_table_name" {
  type = string
}
variable "mfa_keys_table_name" {
  type = string
}
variable "signature_keys_table_name" {
  type = string
}
variable "mfa_account_methods_table_name" {
  type = string
}

# s3 variables
variable "document_s3_bucket_name" {
  type = string
}

# kms variables
variable "key_name" {
  type = string
}
variable "key_administrator_account_ids" {
  type = set(string)
}

variable "key_user_account_ids" {
  type = set(string)
}

variable "key_alias" {
  type = string
}
variable "key_description" {
  type = string
}
variable "deletion_window_in_days" {
  default = 7
}
