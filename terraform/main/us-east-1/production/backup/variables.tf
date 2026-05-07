variable "prefix" {
  type        = string
  description = "Prefix for the resources"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "backup_config" {
  type        = any
  description = "backup_plan configuration"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
}

variable "region_backup" {
  type        = string
  description = "AWS region"
}

variable "source_kms_key_arn" {
  type        = string
  description = "KMS key ARN for the source backup vault"
  default     = ""
}

variable "destination_kms_key_arn" {
  type        = string
  description = "KMS key ARN for the destination backup vault in DR region"
  default     = ""
}

variable "environment" {
  type = string
}

variable "policy_path" {
  type = string
}

variable "backup_policy_arns" {
  type = list(string)
}

variable "short_environment" {
  type        = string
  description = "Short environment name (e.g. prod, dev)"
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
}
