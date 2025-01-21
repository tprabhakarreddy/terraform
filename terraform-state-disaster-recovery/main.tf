# Create source S3 bucket in us-west-1 
resource "aws_s3_bucket" "source" {
  bucket   = "prt-s3-terraform-state-source"
  provider = aws.west1
  force_destroy = true
}

# enable versioning on source S3 bucket

resource "aws_s3_bucket_versioning" "source" {
  bucket = aws_s3_bucket.source.id
  provider = aws.west1
  versioning_configuration {
    status = "Enabled"
  }
}

# Create Destination bucket in us-west-2
resource "aws_s3_bucket" "destination" {
  bucket   = "prt-s3-terraform-state-destination"
  provider = aws.west2
  force_destroy = true
}

# enable versioning on destination S3 bucket

resource "aws_s3_bucket_versioning" "destination" {
  bucket = aws_s3_bucket.destination.id
  provider = aws.west2
  versioning_configuration {
    status = "Enabled"
  }
}

# Create IAM Role
resource "aws_iam_role" "replication_role" {
  name               = "terraform-s3-replication-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Create IAM policy 
resource "aws_iam_role_policy" "replication_policy" {
  name   = "terraform-s3-replication-policy"
  role   = aws_iam_role.replication_role.id
  policy = data.aws_iam_policy_document.replication.json
}


# Replication Configuration for source bucket
resource "aws_s3_bucket_replication_configuration" "source-to-dest" {
  provider   = aws.west1
  depends_on = [aws_s3_bucket_versioning.source]
  role       = aws_iam_role.replication_role.arn
  bucket     = aws_s3_bucket.source.id

  rule {
    id     = "rule-1"
    status = "Enabled"
    destination {
      bucket = aws_s3_bucket.destination.arn
    }
  }

}