function copy_tf_variables() {
  echo $ACCOUNT_ID
  sed 's/ACCOUNT_ID/'$ACCOUNT_ID'/g' variables.tfvars | sed 's/VAUTHENTICATOR_BUCKET/'$VAUTHENTICATOR_BUCKET'/g' > variables.tfvars
}

source .env

cd terraform

ln -s variable.tf iam/variable.tf
ln -s variable.tf policy/variable.tf
ln -s variable.tf resources/variable.tf

cd policy
copy_tf_variables

terraform init -backend-config="bucket=$TF_STATE_BUCKET" -backend-config="region=$AWS_REGION"
terraform destroy --auto-approve -var-file=variables.tfvars

cd ../resources
copy_tf_variables

terraform init -backend-config="bucket=$TF_STATE_BUCKET" -backend-config="region=$AWS_REGION"
terraform destroy --auto-approve -var-file=variables.tfvars


# IAM
cd ../iam
copy_tf_variables

terraform init -backend-config="bucket=$TF_STATE_BUCKET" -backend-config="region=$AWS_REGION"
terraform destroy --auto-approve -var-file=variables.tfvars

