# Create EC2 instance
resource "aws_instance" "ec2" {
  ami             = "ami-07d9cf938edb0739b"
  instance_type   = "t2.micro"
  key_name        = "newkey"
  security_groups = [aws_security_group.sg.name]

  depends_on = [
    aws_security_group.sg
  ]
}

# Create Security Group
resource "aws_security_group" "sg" {
  tags = {
    Name = "mySG"
  }

}

