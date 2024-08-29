provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "vulnerable_instance" {
    ami           = "ami-0c55b159cbfafe1f0"  # Publicly available AMI
    instance_type = "t2.micro"

    # Vulnerable: publicly accessible IP
    associate_public_ip_address = true

    # Vulnerable: Hard-coded credentials in the Terraform file
    user_data = <<-EOF
    #!/bin/bash
    echo "AccessKey=AKIAIOSFODNN7EXAMPLE" >> /etc/creds
    echo "SecretKey=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY" >> /etc/creds
    EOF

    # Misconfigured: Insecure security group
    vpc_security_group_ids = [aws_security_group.insecure_sg.id]

    # Vulnerable: Misconfigured tags
    tags = {
        Name = "vulnerable-instance"
    }
}

resource "aws_security_group" "insecure_sg" {
    name_prefix = "insecure_sg"

    ingress {
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # Allows traffic from anywhere
    }

    egress {
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # Allows traffic to anywhere
    }
}

resource "aws_security_group" "example" {
  vpc_id = aws_vpc.example.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # This allows inbound traffic from any IP address
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "secret_data_bucket" {
  bucket = "secret-data-bucket"
  acl    = "private"
  
  tags = {
    Name        = "SecretDataBucket"
    Environment = "Dev"
  }
}


resource "aws_ebs_volume" "my_ebs" {
  availability_zone = "us-west-2a"
  size              = 10
  volume_type       = "gp2"
  tags = {
    Name = "myEBSVolume"
  }
}
