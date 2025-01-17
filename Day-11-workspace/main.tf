# Create S3 bucket
resource "aws_s3_bucket" "name" {
    bucket = "${terraform.workspace}-prt-bucket"
    tags = {
      Name = "${terraform.workspace}-bucket"
    }
  
}
output "name" {
  value = terraform.workspace
}