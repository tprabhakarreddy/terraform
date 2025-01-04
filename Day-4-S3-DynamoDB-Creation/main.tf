resource "aws_instance" "dev" {
  ami           = "ami-07d9cf938edb0739b"
  instance_type = "t2.micro"
  key_name      = "newkey"
  tags = {
    Name = "LocalInstance"
  }

}
