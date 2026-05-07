output "domain_verification_tokens" {
  value = module.ses.domain_verification_tokens
}

output "dkim_tokens" {
  value = module.ses.dkim_tokens
}

output "mail_from_domains" {
  value = module.ses.mail_from_domains
}

output "smtp_endpoint" {
  description = "FIPS SMTP endpoint for SES in GovCloud us-gov-west-1"
  value       = "email-fips.us-gov-west-1.amazonaws.com"
}
