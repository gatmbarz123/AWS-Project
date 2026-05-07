# General
variable "prefix" {
  type        = string
  description = "Prefix for the resources"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "short_region" {
  type        = string
  description = "Short AWS region"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "short_environment" {
  type        = string
  description = "Short name for the environment (e.g. dev, staging, prod)"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
}
