variable "prefix" {
  type        = string
  description = "Prefix for the resources"
}
variable "environment" {
  type = string
}

variable "short_environment" {
  type = string
}

variable "region" {
  type = string
}
variable "short_region" {
  type = string
}

variable "aws_account_id" {
  type        = string
  description = "AWS account ID"
}

variable "policy_iam_path" {
  type        = string
  description = "Path to the iam policy folder"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the resources"
}
