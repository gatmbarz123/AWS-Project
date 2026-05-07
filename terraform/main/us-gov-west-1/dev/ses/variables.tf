variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "prefix" {
  type = string
}

variable "tags" {
  type = any
}

variable "domain_identities" {
  type    = list(string)
  default = []
}

variable "email_identities" {
  type    = list(string)
  default = []
}

variable "mail_from_domains" {
  type    = map(string)
  default = {}
}

variable "configuration_sets" {
  type    = list(string)
  default = []
}
