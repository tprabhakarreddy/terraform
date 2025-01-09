module "name" {
  source        = "terraform-aws-modules/ec2-instance/aws"
  ami           = "ami-07d9cf938edb0739b"
  instance_type = "t2.micro"
  key_name      = "newkey"
}

