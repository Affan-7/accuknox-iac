provider "aws" {
    region = "ap-south-1"
    profile = "affan-accuknox-personal"
}

resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  description = "Security group with all ports open to the public"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"  # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}