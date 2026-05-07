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

variable "s3_buckets" {
  type = any
}

# KMS 

variable "kms_description" {
  type = string
}

variable "kms_alias" {
  type    = string
  default = null
}

variable "kms_rotation_period_in_days" {
  type    = number
  default = 365
}

variable "kms_deletion_window_in_days" {
  type    = number
  default = 30
}

variable "kms_multi_region" {
  type    = bool
  default = false
}