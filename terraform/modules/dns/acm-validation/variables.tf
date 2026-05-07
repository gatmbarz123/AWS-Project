variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "management_account_id" {
  type = string
}

variable "management_role_name" {
  type = string
}

variable "public_hosted_zone_name" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "domain_validation_options" {
  type = any
}

