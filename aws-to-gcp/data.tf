# Pull ami information
data "aws_ami" "aws" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.1.20230705.0-kernel-6.1-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Canonical
}

# Pull domain information
data "aws_route53_zone" "selected" {
  name         = var.google_domain_name
  private_zone = false
}
