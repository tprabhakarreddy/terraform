locals {
  environment = "dev"
  instance_type = "t3.micro"
}

resource "aws_instance" "example" {
  ami           = "ami-07d9cf938edb0739b"
  instance_type = local.instance_type
  key_name = "newkey"

  tags = {
    Environment = local.environment
  }
}
