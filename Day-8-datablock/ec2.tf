resource "aws_instance" "ec2" {
  ami           = data.aws_ami.name.id
  instance_type = "t2.micro"
  key_name      = "newkey"
  subnet_id     = data.aws_subnet.name.id
}
