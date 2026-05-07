resource "aws_ses_domain_identity" "domain" {
  for_each = toset(var.domain_identities)
  domain   = each.value
}

resource "aws_ses_domain_dkim" "dkim" {
  for_each = toset(var.domain_identities)
  domain   = aws_ses_domain_identity.domain[each.value].domain
}

resource "aws_ses_domain_mail_from" "mail_from" {
  for_each         = var.mail_from_domains
  domain           = aws_ses_domain_identity.domain[each.key].domain
  mail_from_domain = each.value
}

resource "aws_ses_email_identity" "email" {
  for_each = toset(var.email_identities)
  email    = each.value
}

resource "aws_ses_configuration_set" "config_set" {
  for_each = toset(var.configuration_sets)
  name     = each.value
}
