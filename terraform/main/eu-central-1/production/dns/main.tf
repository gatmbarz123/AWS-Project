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

module "acm_validation" {
  source                    = "../../../../modules/dns/acm-validation"
  certificate_arn           = module.acm.certificate_arn
  domain_validation_options = module.acm.domain_validation_options
  region                    = var.region
  environment               = var.environment
  management_account_id     = var.management_account_id
  management_role_name      = var.management_role_name
  public_hosted_zone_name   = var.public_hosted_zone_name
}

# Add authorization for the VPC to the private hosted zone for Dev VPC.
module "vpc_association_authorization_private_hosted_zone" {
  source = "../../../../modules/dns/vpc-association-authorization"

  vpc_id  = var.dev_vpc_id
  zone_id = module.hosted_zone.zone_id
}
