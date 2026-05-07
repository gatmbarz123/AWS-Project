variable "user_name" {
  type        = string
  description = "IAM user name"
}

variable "policy_arns" {
  type        = list(string)
  description = "List of IAM policy ARNs to attach to the user"
  default     = []
}

variable "inline_policies" {
  type        = map(string)
  description = "Map of inline policy name => policy JSON to attach to the user"
  default     = {}
}

variable "secret_name_prefix" {
  type        = string
  description = "Prefix for the Secrets Manager secret path (e.g. 'iam/dev')"
  default     = "iam"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the user"
  default     = {}
}
