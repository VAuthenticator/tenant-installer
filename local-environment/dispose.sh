function copy_tf_variables() {
  echo $ACCOUNT_ID
  sed 's/ACCOUNT_ID/'$ACCOUNT_ID'/g' ../../../terraform-ovverrides/variables.tfvars | sed 's/VAUTHENTICATOR_BUCKET/'$VAUTHENTICATOR_BUCKET'/g'  > variables.tfvars
}

rm -rf tenant-installer
source .env

cd tenant-installer/terraform/

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

