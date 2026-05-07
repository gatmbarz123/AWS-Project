variable "prefix" {
  type = string
}

variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "private_hosted_zone_name" {
  type = string
}

variable "public_acm_domain_name" {
  type = string
}

variable "public_acm_subject_alternative_names" {
  type    = list(string)
  default = []
}

variable "tags" {
  type = any
}
