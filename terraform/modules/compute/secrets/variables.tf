# General
variable "prefix" {
  type = string
}

variable "secret_name_prefix" {
  type = string
}

variable "short_environment" {
  type        = string
  description = "Short name for the environment (e.g. dev, staging, prod)"
}

variable "short_region" {
  type        = string
  description = "Short AWS region"
}

variable "partition" {
  type        = string
  description = "AWS partition (e.g. aws-us-gov)"
}

variable "region" {
  type        = string
  description = "AWS region"
}

# Tags
variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}
