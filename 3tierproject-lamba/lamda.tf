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
    ],
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
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


# Create the Layer
resource "aws_lambda_layer_version" "mysql_layer" {
  layer_name          = "mysql-layer"
  description         = "Layer with MySQL connector dependencies"
  compatible_runtimes = ["python3.9", "python3.8", "python3.7"]
  filename            = "python.zip"

}



# Deploy Lambda function
resource "aws_lambda_function" "example_lambda" {
  function_name = "example-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  filename      = "lambda_function.zip"
  timeout       = 900
  environment {
    variables = {
      DB_HOST     = replace(aws_db_instance.mysql_db.endpoint, ":3306", "")
      DB_USER     = aws_db_instance.mysql_db.username
      DB_PASSWORD = aws_db_instance.mysql_db.password
    }
  }
  depends_on = [aws_db_instance.mysql_db]
  layers     = [aws_lambda_layer_version.mysql_layer.arn]
  vpc_config {
    subnet_ids = [aws_subnet.private-subnet["private1a"].id,
      aws_subnet.private-subnet["private2b"].id,
      aws_subnet.public-subnet["public1a"].id,
      aws_subnet.public-subnet["public2b"].id
    ]
    security_group_ids = [aws_security_group.mySG.id]
  }

}

# Invoke lambda function
resource "null_resource" "invoke_lambda" {
  provisioner "local-exec" {
    command = "python3 invoke_lambda.py"
  }

  depends_on = [aws_lambda_function.example_lambda]
}