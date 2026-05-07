resource "aws_route53_vpc_association_authorization" "this" {
  vpc_id  = var.vpc_id
  zone_id = var.zone_id
}