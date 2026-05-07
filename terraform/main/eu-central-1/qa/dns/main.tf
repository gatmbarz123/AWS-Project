# Hosted Zone
module "hosted_zone" {
  source = "../../../../modules/dns/private-hosted-zone"

  name   = var.private_hosted_zone_name
  vpc_id = data.aws_vpc.vpc.id
  tags   = var.tags
}

module "acm" {
  source = "../../../../modules/dns/acm"

  domain_name               = var.public_acm_domain_name
  subject_alternative_names = var.public_acm_subject_alternative_names

  tags = var.tags
}