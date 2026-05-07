variable "description" {
  type        = string
  description = "Description for the CMK"
}

variable "alias" {
  type        = string
  description = "Alias name (without 'alias/')"
  default     = null
}

variable "rotation_period_in_days" {
  type        = number
  description = "Automatic rotation period for the CMK in days"
  default     = 365
}

variable "deletion_window_in_days" {
  type        = number
  description = "Waiting period for CMK deletion"
  default     = 30
}

variable "multi_region" {
  type        = bool
  description = "Create a multi-Region key"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags for the CMK"
  default     = {}
}