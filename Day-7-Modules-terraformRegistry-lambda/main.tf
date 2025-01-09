module "name" {
  source                 = "terraform-aws-modules/lambda/aws"
  function_name          = "my-function"
  handler                = "lambda_function.lambda_handler"
  runtime                = "python3.12"
  create_package         = false
  local_existing_package = "lambda_function.zip"
  #local_existing_package = "../Day-6-Lambda-Creation-withoutS3/lambda_function.zip"
}

