data "aws_route53_zone" "public" {
  name = var.public_hosted_zone_name
}
