# Create EC2 instance
resource "aws_instance" "ec2" {
  ami           = "ami-07d9cf938edb0739b"
  instance_type = "t2.micro"
  key_name      = "newkey"
}

# Create S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "prt-bucket-name"
}

## terraform apply -auto-approve -target=aws_instance.ec2
