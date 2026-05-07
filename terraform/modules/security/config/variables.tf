
variable "prefix" {
  type        = string
  description = "The prefix for the AWS Config resources."
}

variable "s3_bucket_name_logs" {
  type        = string
  description = "The name of the S3 bucket for storing logs."
}

variable "config_rules" {
  type = list(object({
    name              = string
    source_identifier = string
  }))
  description = "List of AWS Config rules with name and source identifier."
}

variable "manage_service_linked_role" {
  type        = bool
  description = "Whether this workspace manages the AWS Config service-linked role. Enable in ONE region only."
  default     = false
}


