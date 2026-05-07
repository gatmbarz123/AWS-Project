variable "prefix" {
  type        = string
  description = "Prefix for the resources"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
}
