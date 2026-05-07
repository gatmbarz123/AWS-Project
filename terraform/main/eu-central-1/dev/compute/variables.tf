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

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
}

# EKS
variable "cluster_version" {
  type        = string
  description = "EKS cluster version"
}

variable "eks" {
  type        = any
  description = "EKS configuration"
}