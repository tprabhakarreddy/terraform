# Instructions:
# 1. Before initializing Terraform, comment out the "backend" block below.
# 2. Apply Terraform to create the required S3 bucket and DynamoDB table.
# 3. Uncomment the "backend" block and run `terraform init` again to configure the backend.

# terraform {
#   backend "s3" {
#     bucket         = "prt-s3-terraform-state-source"
#     key            = "terraform/state.tfstate"
#     region         = "us-west-1"
#     encrypt        = true
#   }
# }