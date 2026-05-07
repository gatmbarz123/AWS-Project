variable "prefix" {
  type = string
}

variable "dev_account_id" {
  type = string
}

variable "production_account_id" {
  type = string
}

variable "staging_account_id" {
  type = string
}

variable "demo_account_id" {
  type = string
}

variable "public_hosted_zone_name" {
  type = string
}

variable "policy_path" {
  type = string
}

variable "tags" {
  type = map(string)
}