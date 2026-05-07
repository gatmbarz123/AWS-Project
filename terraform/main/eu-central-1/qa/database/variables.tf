# General
variable "prefix" {
  type        = string
  description = "Prefix for the resources"
}
variable "environment" {
  type        = string
  description = "Environment"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "short_region" {
  type        = string
  description = "Short AWS region"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
}

variable "rds_aurora" {
  type        = any
  description = "RDS Aurora configuration"
}