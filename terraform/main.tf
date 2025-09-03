data "aws_ami" "ubuntu_2204" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false
}

resource "aws_s3_bucket" "site" {
  bucket        = "tc3-${random_string.suffix.result}"
  force_destroy = true

  versioning {
    enabled = true
  }

  tags = {
    Project = "TechChallenge3"
  }
}

# IAM Role for EC2 to (optionally) access the S3 bucket
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "tc3-ec2-role-${random_string.suffix.result}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "s3_access" {
  statement {
    sid     = "AllowS3ReadList"
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.site.arn,
      "${aws_s3_bucket.site.arn}/*"
    ]
  }
}

resource "aws_iam_role_policy" "s3_policy" {
  name   = "tc3-ec2-s3-policy-${random_string.suffix.result}"
  role   = aws_iam_role.ec2_role.id
  policy = data.aws_iam_policy_document.s3_access.json
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "tc3-ec2-profile-${random_string.suffix.result}"
  role = aws_iam_role.ec2_role.name
}

# Security group to allow SSH and HTTP
resource "aws_security_group" "web_sg" {
  name        = "tc3-web-sg-${random_string.suffix.result}"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allow_ssh_cidr]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allow_http_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = "TechChallenge3"
  }
}

# Use default VPC and first public subnet (simple for challenge)
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# We'll pick the first subnet (in default VPC) — fine for this challenge
locals {
  first_subnet_id = data.aws_subnets.default_public_subnets.ids[0]
}

# Key pair (created from your local PUBLIC key path)
resource "aws_key_pair" "this" {
  key_name   = "tc3-key-${random_string.suffix.result}"
  public_key = chomp(file(var.public_key_path))
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu_2204.id
  instance_type               = var.instance_type
  subnet_id                   = local.first_subnet_id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = aws_key_pair.this.key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = true

  tags = {
    Name    = "tc3-web"
    Project = "TechChallenge3"
  }
}
