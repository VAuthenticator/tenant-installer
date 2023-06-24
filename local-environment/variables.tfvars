# tags variables
common_resource_tags = {}

# iam variables
username = "vauthenticator-local-dev"
path = "/local-stage/"

# dynamodb variables
table_name_suffix  = "_Local_Staging"

# s3 variables
document_s3_bucket_name = "VAUTHENTICATOR_BUCKET"

# kms variables
key_name                      = "master_key"
key_administrator_account_ids = ["arn:aws:iam::ACCOUNT_ID:user/local-stage/vauthenticator-local-dev"]
key_user_account_ids = ["arn:aws:iam::ACCOUNT_ID:user/local-stage/vauthenticator-local-dev"]

key_alias               = "vauthenticator-key"
key_description         = "vauthenticator-key"
deletion_window_in_days = 7
