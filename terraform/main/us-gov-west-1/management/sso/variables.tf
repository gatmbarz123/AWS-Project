# General
variable "region" {
  type = string
}

variable "environment" {
  type = string
}

# Users

variable "sso_users" {
  type = any
}

variable "sso_groups" {
  type = any
}

variable "sso_group_memberships" {
  type = any
}

variable "permission_sets" {
  type = any
}

variable "account_assignments" {
  type = any
}