resource "aws_instance" "public" {
  ami                         = "ami-07d9cf938edb0739b"
  instance_type               = "t2.micro"
  key_name                    = "newkey"
  availability_zone           = "us-west-2a"
  subnet_id                   = aws_subnet.subnet-1.id
  security_groups             = [aws_security_group.sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "PublicEC2"
  }

}

