# Hosted Zone
module "hosted_zone" {
  source = "../../../../modules/dns/public-hosted-zone"

  name = var.public_hosted_zone_name
  tags = var.tags
}

# Subdomain zone for GovCloud (temporary - until VPN is set up)
module "usgw1_hosted_zone" {
  source = "../../../../modules/dns/public-hosted-zone"

  name = "usgw1.example.com"
  tags = var.tags
}

resource "aws_route53_record" "usgw1_ns" {
  zone_id = module.hosted_zone.zone_id
  name    = "usgw1.example.com"
  type    = "NS"
  ttl     = 300
  records = module.usgw1_hosted_zone.ns_records
}

# Temporary example-app zone - until VPN is set up and dev reverts to internal-only
module "example-app_hosted_zone" {
  source = "../../../../modules/dns/public-hosted-zone"

  name = "example-app.example.com"
  tags = var.tags
}

resource "aws_route53_record" "example-app_ns" {
  zone_id = module.hosted_zone.zone_id
  name    = "example-app.example.com"
  type    = "NS"
  ttl     = 300
  records = module.example-app_hosted_zone.ns_records
}

# SES domain verification for example.com
resource "aws_route53_record" "ses_domain_verification" {
  zone_id = module.hosted_zone.zone_id
  name    = "_amazonses.example.com"
  type    = "TXT"
  ttl     = 300
  records = ["example-ses-verification-token"]
}

# SES DKIM records for example.com
resource "aws_route53_record" "ses_dkim" {
  for_each = toset([
    "example-dkim-token-1",
    "example-dkim-token-2",
    "example-dkim-token-3",
  ])

  zone_id = module.hosted_zone.zone_id
  name    = "${each.value}._domainkey.example.com"
  type    = "CNAME"
  ttl     = 300
  records = ["${each.value}.dkim.amazonses.com"]
}

# SES MAIL FROM domain: ses-dev.example.com
resource "aws_route53_record" "ses_dev_mail_from_mx" {
  zone_id = module.hosted_zone.zone_id
  name    = "ses-dev.example.com"
  type    = "MX"
  ttl     = 600
  records = ["10 feedback-smtp.us-gov-west-1.amazonaws.com"]
}

resource "aws_route53_record" "ses_dev_mail_from_spf" {
  zone_id = module.hosted_zone.zone_id
  name    = "ses-dev.example.com"
  type    = "TXT"
  ttl     = 600
  records = ["v=spf1 include:amazonses.com ~all"]
}

# DMARC for example.com
resource "aws_route53_record" "ses_dmarc" {
  zone_id = module.hosted_zone.zone_id
  name    = "_dmarc.example.com"
  type    = "TXT"
  ttl     = 3600
  records = ["v=DMARC1; p=quarantine; adkim=r; aspf=r; rua=mailto:user@example.com;"]
}

# ACM validation for *.example-app.example.com cert (created in dev/dns)
resource "aws_route53_record" "example-app_acm_validation" {
  zone_id = module.example-app_hosted_zone.zone_id
  name    = "_ab0de23f9adb70c53fcd649b6aaea5d4.example-app.example.com"
  type    = "CNAME"
  ttl     = 300
  records = ["_d62dd46e870f4f349d126e7439b3f2ad.jkddzztszm.acm-validations.aws."]
}


