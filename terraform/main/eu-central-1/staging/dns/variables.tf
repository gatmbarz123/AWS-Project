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

variable "public_hosted_zone_name" {
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

variable "management_account_id" {
  type = string
}

variable "management_role_name" {
  type = string
}

variable "dev_vpc_id" {
  type = string
}

variable "dev_windows_vpc_id" {
  type = string
}