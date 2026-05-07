variable "guardduty_enable" {
  type        = bool
  description = "Enable or disable AWS GuardDuty."
}

variable "auto_enable_organization_members" {
  type        = string
  description = "Enable or disable automatic enabling of organization members."
}

variable "configuration_features" {
  description = "Map of GuardDuty feature configurations"
  type        = map(any)
}

variable "admin_account_id" {
  description = "ID of the organization management account"
  type        = string
}

