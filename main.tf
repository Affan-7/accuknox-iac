provider "aws" {
    region = "ap-south-1"
    profile = "affan-accuknox-personal"
}

resource "aws_s3_bucket" "sensitive-data2-bucket" {
  bucket = "sensitive-data2"
}

resource "aws_s3_bucket_public_access_block" "sensitive-data2-bucket-public-access" {
  bucket = aws_s3_bucket.sensitive-data2-bucket.id

  block_public_acls   = false
  block_public_policy = false
}

resource "aws_s3_bucket_ownership_controls" "sensitive-data2-bucket-owner-preferred" {
  bucket = aws_s3_bucket.sensitive-data2-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_public_access_block.sensitive-data2-bucket-public-access,
    aws_s3_bucket_ownership_controls.sensitive-data2-bucket-owner-preferred,
  ]

  bucket = aws_s3_bucket.sensitive-data2-bucket.id
  acl    = "authenticated-read"
}