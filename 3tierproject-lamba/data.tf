# Retrive the FrontEnd AMI information
data "aws_ami" "FrontEnd-ami" {
  most_recent = true
  owners      = ["self"] # Replace with the AWS account ID if needed

  filter {
    name   = "name"
    values = ["Frontend*"] # Use your AMI name pattern
  }
}

# Retrive the BackEnd AMI information

data "aws_ami" "BackEnd-ami" {
  most_recent = true
  owners      = ["self"] # Replace with the AWS account ID if needed

  filter {
    name   = "name"
    values = ["Backend*"] # Use your AMI name pattern
  }
}

