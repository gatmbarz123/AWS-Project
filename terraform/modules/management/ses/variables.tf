variable "domain_identities" {
  type        = list(string)
  description = "List of domains to verify in SES"
  default     = []
}

variable "email_identities" {
  type        = list(string)
  description = "List of email addresses to verify in SES"
  default     = []
}

variable "mail_from_domains" {
  type        = map(string)
  description = "Map of domain => mail-from subdomain (e.g. { 'example.com' = 'ses-dev.example.com' })"
  default     = {}
}

variable "configuration_sets" {
  type        = list(string)
  description = "List of SES configuration set names to create"
  default     = []
}

