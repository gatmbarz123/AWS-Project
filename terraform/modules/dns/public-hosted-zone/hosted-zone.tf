resource "aws_route53_zone" "public" {
  name = var.name
  tags = var.tags
}