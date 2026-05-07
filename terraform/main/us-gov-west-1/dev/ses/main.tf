module "ses" {
  source = "../../../../modules/management/ses"

  domain_identities  = var.domain_identities
  email_identities   = var.email_identities
  mail_from_domains  = var.mail_from_domains
  configuration_sets = var.configuration_sets
}
