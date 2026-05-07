# General
variable "environment" {
  type = string
}
variable "short_environment" {
  type = string
}
variable "region" {
  type = string
}
variable "aws_account_id" {
  type = string
}
variable "short_region" {
  type = string
}
variable "prefix" {
  type = string
}

# VPC 
variable "vpc" {
  description = "Map of VPC configurations"
  type        = map(any)
  default     = {}
}

# Flow Logs
variable "enable_flow_log" {
  type = bool
}
variable "create_flow_log_cloudwatch_log_group" {
  type = bool
}
variable "create_flow_log_cloudwatch_iam_role" {
  type = bool
}
variable "flow_log_max_aggregation_interval" {
  type    = number
  default = null
}
variable "flow_log_cloudwatch_log_group_retention_in_days" {
  type    = number
  default = null
}
variable "flow_log_cloudwatch_log_group_class" {
  type    = string
  default = null
}

# Tags
variable "tags" {
  type = map(string)
}