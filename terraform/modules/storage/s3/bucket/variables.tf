#  General
variable "prefix" {
  description = "Prefix for the resources"
  type        = string
}

# S3
variable "name" {
  description = "S3 bucket name"
  type        = string
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket"
  type        = bool
  default     = true
}

variable "versioning_status" {
  description = "Enable versioning"
  type        = string
  default     = "Disabled"
}

variable "bucket_policy_file" {
  description = "Path to the bucket policy file"
  type        = string
  default     = null
}

variable "enable_logging" {
  description = "Enable server access logging for the S3 bucket"
  type        = bool
  default     = false
}

variable "logging_target_bucket" {
  description = "The name of the bucket where you want Amazon S3 to store server access logs"
  type        = string
  default     = null
}

variable "logging_target_prefix" {
  description = "A prefix for all log object keys (e.g., 'logs/' creates a 'logs/' folder in the target bucket)"
  type        = string
  default     = null
}


variable "tags" {
  description = "Tags for the S3 bucket"
  type        = map(string)
}

variable "sqs_notifications" {
  description = "Configuration for SQS notifications. Leave empty to disable."
  type = list(object({
    events        = list(string)
    filter_prefix = optional(string)
    filter_suffix = optional(string)
  }))
  default = []
}

variable "enable_eventbridge" {
  description = "Enable EventBridge notifications for this bucket."
  type        = bool
  default     = false
}

variable "create_sqs" {
  description = "Whether to create an SQS queue policy allowing S3 to send messages"
  type        = bool
  default     = false
}

variable "aws_account_id" {
  description = "The AWS account ID of the bucket owner"
  type        = string
  default     = ""
}

variable "cors_rules" {
  description = "List of CORS rules for the S3 bucket"
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  }))
  default = []
}
