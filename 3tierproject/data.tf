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

# Data source to get the public Route 53 hosted zone
data "aws_route53_zone" "public_zone" {
  name         = "clouddevops.co.in" # Replace with your domain name
  private_zone = false               # This filters for public hosted zones
}


# Fetch Latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}