variable "region" {
  description = "AWS region to deploy Config and Security Hub."
  type        = string
}

variable "account_id" {
  description = "AWS Account ID."
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "is_management_account" {
  description = "Set to true if this is the management account."
  type        = bool
  default     = false
}

variable "member_account_ids" {
  description = "List of AWS Organization member account IDs (only needed in management account)."
  type        = list(string)
  default     = []
}