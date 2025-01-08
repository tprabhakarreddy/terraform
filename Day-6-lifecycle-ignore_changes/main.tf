resource "aws_instance" "ec2" {
  ami           = "ami-07d9cf938edb0739b"
  instance_type = "t2.micro"
  key_name      = "newkey"
  tags = {
    Name = "EC2"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
