
variable "prefix" {
  description = "The prefix"
  type        = string
}


#############################
# Vault names / encryption
#############################
variable "source_kms_key_arn" {
  description = "KMS key ARN for the source vault"
  type        = string
}

variable "destination_kms_key_arn" {
  description = "KMS key ARN for the destination vault"
  type        = string
}

variable "force_destroy" {
  description = "If true, terraform destroy will purge recovery points"
  type        = bool
  default     = false
}

#############################
# Backup plan parameters rule daily
#############################
variable "name" {
  type = string
}
variable "schedule_cron_daily" {
  type = string
}

variable "start_window_daily" {
  type = number
} # minutes

variable "completion_window_daily" {
  type = number
} # minutes

variable "delete_after_daily" {
  type = number
} # days

#############################
# Backup plan parameters rule weekly
#############################
variable "schedule_cron_weekly" {
  type = string
}

variable "start_window_weekly" {
  type = number
} # minutes

variable "completion_window_weekly" {
  type = number
} # minutes

variable "delete_after_weekly" {
  type = number
} # days

#############################
# Backup plan parameters rule monthly
#############################
variable "schedule_cron_monthly" {
  type = string
}

variable "start_window_monthly" {
  type = number
} # minutes

variable "completion_window_monthly" {
  type = number
} # minutes

variable "delete_after_monthly" {
  type = number
} # days

#############################
# Backup plan parameters rule yearly
#############################
variable "schedule_cron_yearly" {
  type = string
}

variable "start_window_yearly" {
  type = number
} # minutes

variable "completion_window_yearly" {
  type = number
} # minutes

variable "delete_after_yearly" {
  type = number
} # days

#############################
# Generic tags
#############################
variable "tags" {
  description = "Map of tags to add to created resources"
  type        = map(string)
}

variable "service_arn" {
  type = string
}

variable "policy_path" {
  type = string
}

variable "backup_policy_arns" {
  type = list(string)
}