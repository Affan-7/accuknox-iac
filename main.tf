provider "aws" {
    region = "ap-south-1"
    profile = "affan-accuknox-personal"
}

resource "aws_instance" "my_instance" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"

    associate_public_ip_address = true

    user_data = <<-EOF
    #!/bin/bash
    echo "AccessKey=AKIAIOSFODNN7EXAMPLE" >> /etc/creds
    echo "SecretKey=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY" >> /etc/creds
    EOF

    vpc_security_group_ids = [aws_security_group.my_sg.id]

    tags = {
        Name = "my-instance"
    }
}

resource "aws_security_group" "my_sg" {
    name_prefix = "my_sg"

    ingress {
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
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