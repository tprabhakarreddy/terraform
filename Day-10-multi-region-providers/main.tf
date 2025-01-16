provider "aws" {
  region = "us-west-2"
  
}
provider "aws" {
  region = "us-west-1"
  alias = "west-1"
}

resource "aws_s3_bucket" "s3_west-2" {
    bucket = "prt-test-s3-west-2"
}

resource "aws_s3_bucket" "s3_west-1" {
    provider = aws.west-1
    bucket = "prt-test-s3-west-1"
}