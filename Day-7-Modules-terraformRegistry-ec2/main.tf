module "name" {
  source        = "github.com/terraform-aws-modules/terraform-aws-ec2-instance"
  ami           = "ami-07d9cf938edb0739b"
  instance_type = "t2.micro"
  key_name      = "newkey"
}

