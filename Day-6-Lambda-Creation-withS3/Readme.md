Topics discussed in today's class
-----------------------------------------
1. Lamda creation process in Terraform
2. Life Cycle rules in Terraform
3. -target Option in Terraform
4. depends_on Option in Terraform
5. User_data option in Terraform
----------------------------------------------------------------------------------

### Lamda creation process with S3 in Terraform
### Steps Overview:
- Prepare the Lambda function code (`lambda_function.py`).  
- Create a unix script for zipping `lambda_function.py` and call terraform commands.  
- Write the Terraform configuration file to create the Lambda function in `lambda.tf`.  
- Run the Unix shell script to zip the code and apply the Terraform configuration.  

### 1. Prepare the Lambda function code (lambda_function.py)
Write the Lambda Code: Write the Lambda function (e.g., lambda_function.py).
```
def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': 'Hello from Lambda with S3!'
    }
```
-----------------------------------------------------------------------------------------------

### 2. Create a Unix Script to Zip the Code and Apply Terraform Commands
Write a Unix shell script (`deploy_lambda.sh`) that will:  
- Zip the `lambda_function.py` file into `lambda_function.zip`.
- Run `terraform` commands to apply the configuration.

```
#!/bin/bash

# Create a ZIP file
if [ ! -f "lambda_function.zip" ]; then
    zip -j  lambda_function.zip lambda_function.py
fi 

# Run Terraform command

#terraform destroy -auto-approve
terraform apply -auto-approve
```
----------------------------------------------------------------------------------------------
### 3. Write the Terraform Configuration File (lambda.tf)
Now, you will define the Terraform configuration in a file called `lambda.tf` to create the Lambda function and IAM role. Here's the Terraform configuration:

**Define S3 Bucket**
```
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "prt-lambda-bucket" # Replace with a unique bucket name
}
```
**Upload Code to S3**
```
resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  key    = "lambda_function.zip"   # File name in the bucket
  source = "./lambda_function.zip" # Path to the local ZIP file
}
```

**Define IAM Role for Lambda**
```
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}
```
**Define IAM Policy Document**
```
resource "aws_iam_policy" "lambda_policy" {
  name = "lambda_policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*"
      }
    ]
  })
}
```
**Attach IAM Policy to Role**
```
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
```
**Define Lambda Function Resource**
```
resource "aws_lambda_function" "example_lambda" {
  function_name = "example-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  s3_bucket     = aws_s3_bucket.lambda_bucket.bucket # S3 bucket name
  s3_key        = aws_s3_object.lambda_zip.key       # S3 object key
}
```
----------------------------------------------------------------------------------------------
### 3. Run the Unix shell script to zip the code and apply the Terraform configuration
Run the script to zip the Lambda code and apply the Terraform configuration  
```
./deploy_lambda.sh
```
-----------------------------------------------------------------------------------------------