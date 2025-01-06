terraform {
  backend "s3" {
    bucket         = "prt-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "TerraformLockTable"
    encrypt        = true
  }
}
