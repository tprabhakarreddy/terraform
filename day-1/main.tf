terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0, <6.0"
    }
  }
}

resource "aws_instance" "name" {
  ami           = "ami-07d9cf938edb0739b"
  instance_type = var.instance_type
  key_name      = "newkey"

}
