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


# Temporary: ACM cert for example-app domain - remove when VPN is set up
module "acm_example-app" {
  source = "../../../../modules/dns/acm"

  domain_name               = "*.example-app.example.com"
  subject_alternative_names = []

  tags = var.tags
}


# Add Zone Association for dev VPC to the private hosted zone in production account.
module "zone_association" {
  source = "../../../../modules/dns/zone-association"

  for_each = toset(var.private_hosted_zone_ids)

  vpc_id  = data.aws_vpc.vpc.id
  zone_id = each.key
}


# module "stg_zone_association_windows_vpc" {
#   source  = "../../../../modules/dns/zone-association"
#   vpc_id  = data.aws_vpc.vpc_windows.id
#   zone_id = var.private_hosted_zone_ids[1]
# }

module "hosted_zone_windows_vpc_association" {
  source = "../../../../modules/dns/vpc-association-authorization"

  vpc_id  = data.aws_vpc.vpc_windows.id
  zone_id = module.hosted_zone.zone_id
}

