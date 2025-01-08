resource "aws_s3_bucket" "s3" {
   bucket = "prt-s3-bucket"
   lifecycle {
    prevent_destroy = true
  }
}