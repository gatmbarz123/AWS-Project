data "aws_route53_zone" "public" {
  provider = aws.management
  name     = var.public_hosted_zone_name
}

data "aws_partition" "current" {}
