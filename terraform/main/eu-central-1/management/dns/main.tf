# Hosted Zone
module "hosted_zone" {
  source = "../../../../modules/dns/public-hosted-zone"

  name = var.public_hosted_zone_name
  tags = var.tags
}