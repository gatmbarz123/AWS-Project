output "domain_verification_tokens" {
  description = "Map of domain => SES verification token (add as TXT record _amazonses.<domain>)"
  value = {
    for domain, identity in aws_ses_domain_identity.domain :
    domain => identity.verification_token
  }
}

output "dkim_tokens" {
  description = "Map of domain => list of 3 DKIM CNAME tokens"
  value = {
    for domain, dkim in aws_ses_domain_dkim.dkim :
    domain => dkim.dkim_tokens
  }
}

output "mail_from_domains" {
  description = "Map of domain => configured MAIL FROM subdomain"
  value = {
    for k, v in aws_ses_domain_mail_from.mail_from :
    k => v.mail_from_domain
  }
}
