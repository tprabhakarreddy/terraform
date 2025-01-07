# Define S3 Bucket and Upload Code
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "prt-lambda-bucket" # Replace with a unique bucket name
}

# Upload code to S3
resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  key    = "lambda_function.zip"   # File name in the bucket
  source = "./lambda_function.zip" # Path to the local ZIP file
}

# Create IAM role
# Following Json code copied from https://docs.aws.amazon.com/lambda/latest/dg/lambda-intro-execution-role.html

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

# Create IAM policy
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

# Attach policy to IAM role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Deploy Lambda function
resource "aws_lambda_function" "example_lambda" {
  function_name = "example-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  s3_bucket     = aws_s3_bucket.lambda_bucket.bucket # S3 bucket name
  s3_key        = aws_s3_object.lambda_zip.key       # S3 object key
}
