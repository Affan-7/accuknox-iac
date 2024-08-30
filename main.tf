provider "aws" {
    region = "ap-south-1"
    profile = "affan-accuknox-personal"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket"
}