
# Create EC2 instance
resource "aws_instance" "ec2" {
  ami           = var.amiid
  instance_type = var.instancetype
  key_name      = var.keyname
}



